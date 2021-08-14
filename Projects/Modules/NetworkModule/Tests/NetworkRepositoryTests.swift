//
//  NetworkRepositoryTests.swift
//  NetworkModuleTests
//
//  Created by 홍경표 on 2021/07/01.
//  Copyright © 2021 softbay. All rights reserved.
//

import XCTest

@testable import NetworkModule
@testable import ThirdPartyManager

import Moya
import RxSwift

final class NetworkRepositoryTests: XCTestCase {
    
    let decoder: JSONDecoder = .init()
    
    // MARK: GET mock 테스트 (MoyaProvider의 isStub 활용)
    func test_get_mock() {
        let expectation = expectation(description: "GET request should succeed")
        
        let networkRepo = NetworkRepository<MockTodosAPI>(isStub: true)
        
        let getMockEndpoint: MockTodosAPI = .getTodo(id: 1)
        let expected: MockTodo = try! decoder.decode(MockTodo.self, from: getMockEndpoint.sampleData)
        
        _ = networkRepo.fetch(endpoint: getMockEndpoint, for: MockTodo.self)
            .subscribe { response in
                debugPrint("[Response]:", response)
                XCTAssertEqual(response, expected)
                expectation.fulfill()
            } onError: { error in
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    // MARK: GET 실제 데이터 테스트
    func test_get_RealData() throws {
        let expectation = expectation(description: "GET request should succeed")
        
        let networkRepo = NetworkRepository<MockTodosAPI>()
        
        let getModelEndpoint: MockTodosAPI = .getTodo(id: 3)
        let expectedData: Data = Data(
            """
            {
              "userId": 1,
              "id": 3,
              "title": "fugiat veniam minus",
              "completed": false
            }
            """.utf8
        )
        let expected: MockTodo = try! decoder.decode(MockTodo.self, from: expectedData)
            
        _ = networkRepo.fetch(endpoint: getModelEndpoint, for: MockTodo.self)
            .subscribe { response in
                debugPrint("[Response]:", response)
                XCTAssertEqual(response, expected)
                expectation.fulfill()
            } onError: { error in
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    // MARK: GET with Query 실제 데이터 테스트
    func test_get_withQuery() {
        let expectation = expectation(description: "GET request should succeed")
        
        let networkRepo = NetworkRepository<MockTodosAPI>()
        
        let getWithQueryEndpoint: MockTodosAPI = .getTodos(userId: 6, completed: true)
        let expected: [MockTodo] = try! decoder.decode([MockTodo].self, from: getWithQueryEndpoint.sampleData)
        
        _ = networkRepo.fetch(endpoint: getWithQueryEndpoint, for: [MockTodo].self)
            .subscribe { response in
                debugPrint("[Response]:", response)
                XCTAssertEqual(response, expected)
                expectation.fulfill()
            } onError: { error in
                print(error)
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    // MARK: POST 테스트
    func test_post() {
        let expectation = expectation(description: "POST request should succeed")
        
        let networkRepo = NetworkRepository<MockTodosAPI>()
        
        let newTodo: MockTodo = .init(userId: 1, id: 0, title: "piopio")
        let postEndpoint: MockTodosAPI = .create(newTodo)
        let expected: MockTodo = try! decoder.decode(MockTodo.self, from: postEndpoint.sampleData)
        
        _ = networkRepo.fetch(endpoint: postEndpoint, for: MockTodo.self)
            .subscribe { response in
                debugPrint("[Response]:", response)
                XCTAssertEqual(response, expected)
                expectation.fulfill()
            } onError: { error in
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    // MARK: PUT 테스트
    func test_put() {
        let expectation = expectation(description: "POST request should succeed")
        
        let networkRepo = NetworkRepository<MockTodosAPI>()
        
        let todoToUpdate: MockTodo = .init(userId: 1, id: 1, title: "updated title", completed: true)
        let putEndpoint: MockTodosAPI = .updatePut(todo: todoToUpdate)
        let expected: MockTodo = try! decoder.decode(MockTodo.self, from: putEndpoint.sampleData)
        
        _ = networkRepo.fetch(endpoint: putEndpoint, for: MockTodo.self)
            .subscribe { response in
                debugPrint("[Response]:", response)
                XCTAssertEqual(response, expected)
                expectation.fulfill()
            } onError: { error in
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    // MARK: PATCH 테스트
    func test_patch() {
        let expectation = expectation(description: "POST request should succeed")
        
        let networkRepo = NetworkRepository<MockTodosAPI>()
        
        let patchEndpoint: MockTodosAPI = .updatePatch(id: 1, title: "Final Final")
        let expected: MockTodo = try! decoder.decode(MockTodo.self, from: patchEndpoint.sampleData)
        
        _ = networkRepo.fetch(endpoint: patchEndpoint, for: MockTodo.self)
            .subscribe { response in
                debugPrint("[Response]:", response)
                XCTAssertEqual(response, expected)
                expectation.fulfill()
            } onError: { error in
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    // MARK: DELETE 테스트
    func test_delete() {
        let expectation = expectation(description: "POST request should succeed")
        
        let networkRepo = NetworkRepository<MockTodosAPI>()
        
        let deleteEndpoint: MockTodosAPI = .delete(id: 1)
        
        // 현재 테스트 API는 Delete에 대해서 성공 여부가 상관없이 response가 "{ }" 이렇게 내려옴
        let expected: [String: String] = [:]
        
        _ = networkRepo.fetch(endpoint: deleteEndpoint, for: [String: String].self)
            .subscribe { response in
                debugPrint("[Response]:", response)
                XCTAssertEqual(response, expected)
                expectation.fulfill()
            } onError: { error in
                XCTFail(error.localizedDescription)
            }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    // MARK: StatusCode Filter 테스트
    func test_filterSuccessfulStatusCodes() {
        let expectedStatusCode: Int = 404
        
        let networkRepo = NetworkRepository<MockTodosAPI>(isStub: true, sampleStatusCode: expectedStatusCode)
        
        _ = networkRepo.fetch(endpoint: .getTodo(id: 1), for: MockTodo.self)
            .subscribe(onSuccess: { response in
                XCTFail()
            }, onError: { error in
                guard let error = error as? MoyaError else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(error.response?.statusCode, expectedStatusCode)
            })
    }
    
}
