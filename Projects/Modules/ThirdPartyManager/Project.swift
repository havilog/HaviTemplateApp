import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "ThirdPartyManager",
    packages: [
        // remote spm
        .Moya, // Alamofire와 Rx를 한번 더 wrapping하여 테스터블하고 endpoint 사용이 가능한 라이브러리
        .Realm, // 현재 구조에서는 UserDefaults와 Realm을 사용하여 데이터를 저장
        .SnapKit, // 코드로 UI를 쉽게 구현하기 위해 적용
        .ReactorKit, // 단방향 반응형 비동기 처리를 위한 프레임워크
        .RxSwift, // 반응형 프로그래밍에서 비동기 처리를 쉽게 하기 위해 선언
        .Then, // 없으면 개발 못함 ㅎ
        .Swinject, // DI container개념을 도입하여 의존성을 쉽게 주입
        
        // local spm
        .Logger, // Log를 찍기 위한 local SPM
    ],
    dependencies: [
        // remote spm
        .SPM.Moya,
        .SPM.RxMoya,
        .SPM.Realm,
        .SPM.RealmSwift,
        .SPM.SnapKit,
        .SPM.ReactorKit,
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.RxRelay,
        .SPM.Then,
        .SPM.Swinject,
        
        // local spm
        .SPM.Logger,
    ]
)
