import Foundation
import Moya
import RxMoya
import RxSwift

public protocol NetworkRepositoryType {
    // 제네릭하게 API를 받기 위한 associatedtype
    associatedtype EndpointType: TargetType
    
    // Test 작성을 위한 initializer
    init(
        isStub: Bool,
        sampleStatusCode: Int,
        customEndpointClosure: ((EndpointType) -> Endpoint)?,
        printLogs: Bool
    )
    
    // 구현부
    func request<Model: Decodable>(endpoint: EndpointType, for type: Model.Type) -> Single<Model>
    func download(endpoint: EndpointType) -> Observable<Void>
}

public extension NetworkRepositoryType {
    static func consProvider(
        _ isStub: Bool = false,
        _ sampleStatusCode: Int = 200,
        _ customEndpointClosure: ((EndpointType) -> Endpoint)? = nil,
        _ printLogs: Bool = false
    ) -> MoyaProvider<EndpointType> {
        if isStub == false {
            return MoyaProvider<EndpointType>(plugins: printLogs ? [NetworkLoggerPlugin()] : [])
        } else {
            // 테스트 시에 호출되는 stub 클로져
            let endPointClosure = { (target: EndpointType) -> Endpoint in
                let sampleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }

                return Endpoint(
                    url: URL(target: target).absoluteString,
                    sampleResponseClosure: sampleResponseClosure,
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers
                )
            }
            return MoyaProvider<EndpointType>(
                endpointClosure: customEndpointClosure ?? endPointClosure,
                stubClosure: MoyaProvider.immediatelyStub,
                plugins: printLogs ? [NetworkLoggerPlugin()] : []
            )
        }
    }
}

public final class NetworkRepository<EndpointType: TargetType>: NetworkRepositoryType {

    private let provider: MoyaProvider<EndpointType>
    
    public init(
        isStub: Bool = false,
        sampleStatusCode: Int = 200,
        customEndpointClosure: ((EndpointType) -> Endpoint)? = nil,
        printLogs: Bool = false
    ) {
        self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure, printLogs)
    }
    
    public func request<Model: Decodable>(
        endpoint: EndpointType,
        for type: Model.Type
    ) -> Single<Model> {
        let requestString = "\(endpoint.method.rawValue) \(endpoint.path)"
        
        return provider.rx.request(endpoint)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    NetworkLogger.success(requestString, value.statusCode)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            NetworkLogger.error(requestString, response.statusCode, jsonObject)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            NetworkLogger.error(requestString, response.statusCode, rawString)
                        } else {
                            NetworkLogger.error(requestString, response.statusCode)
                        }
                    } else {
                        NetworkLogger.error(requestString, error, error.localizedDescription)
                    }
                },
                onSubscribed: {
                    NetworkLogger.request(requestString)
                }
            )
            .map(Model.self)
    }
    
    public func download(endpoint: EndpointType) -> Observable<Void> {
        let requestString = "\(endpoint.method.rawValue) \(endpoint.path)"
        
        return provider.rx.requestWithProgress(endpoint)
            .do(
                onNext: {
                    NetworkLogger.info("completedUnitCount", $0.progressObject?.completedUnitCount ?? 0)
                },
                onError: { error in
                    NetworkLogger.error(error, error.localizedDescription)
                },
                onSubscribed: {
                    NetworkLogger.request(requestString)
                }
            )
            .filter { $0.completed }
            .do(onNext: { _ in
                NetworkLogger.success("download complete")
            })
            .map { _ in }
    }
}
