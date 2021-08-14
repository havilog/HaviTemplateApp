import ProjectDescription

extension DeploymentTarget {
    public static let defaultDeployment: DeploymentTarget = .iOS(targetVersion: "14.0", devices: .iphone)
}

// BuildSettings Key
public extension String {
    static let marketVersion = "MARKETING_VERSION"
    static let currentProjectVersion = "CURRENT_PROJECT_VERSION"
    static let codeSignIdentity = "CODE_SIGN_IDENTITY"
    static let codeSigningStyle = "CODE_SIGNING_STYLE"
    static let codeSigningRequired = "CODE_SIGNING_REQUIRED"
    static let developmentTeam = "DEVELOPMENT_TEAM"
    static let bundleIdentifier = "Baycon_Bundle_Identifier"
    static let bundleName = "Havi_Bundle_Name"
    static let provisioningProfileSpecifier = "PROVISIONING_PROFILE_SPECIFIER"
}

extension TargetDependency {
    public struct SPM {
    }
}

// dependencies
public extension TargetDependency.SPM {
    static let Moya = TargetDependency.package(product: "Moya")
    static let RxMoya = TargetDependency.package(product: "RxMoya")
    static let Realm = TargetDependency.package(product: "Realm")
    static let RealmSwift = TargetDependency.package(product: "RealmSwift")
    static let SnapKit = TargetDependency.package(product: "SnapKit")
    static let ReactorKit = TargetDependency.package(product: "ReactorKit")
    static let RxSwift = TargetDependency.package(product: "RxSwift")
    static let RxCocoa = TargetDependency.package(product: "RxCocoa")
    static let RxRelay = TargetDependency.package(product: "RxRelay")
    static let Then = TargetDependency.package(product: "Then")
    static let Swinject = TargetDependency.package(product: "Swinject")
    
    // for test
    static let Nimble = TargetDependency.package(product: "Nimble")
    static let Quick = TargetDependency.package(product: "Quick")
    static let RxTest = TargetDependency.package(product: "RxTest")
    static let RxBlocking = TargetDependency.package(product: "RxBlocking")
    
    // local spm
    static let ResourcePackage = TargetDependency.package(product: "ResourcePackage")
    
    static let Logger = TargetDependency.package(product: "Logger")
}

public extension Package {
    // remote spm
    static let Moya = Package.remote(url: "https://github.com/Moya/Moya", requirement: .upToNextMajor(from: "14.0.0"))
    static let Realm = Package.remote(url: "https://github.com/realm/realm-cocoa", requirement: .upToNextMajor(from: "10.8.0"))
    static let SnapKit = Package.remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.1"))
    static let ReactorKit = Package.remote(url: "https://github.com/ReactorKit/ReactorKit", requirement: .upToNextMajor(from: "2.1.1"))
    static let RxSwift = Package.remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "5.0.0"))
    static let Then = Package.remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "2.7.0"))
    static let Swinject = Package.remote(url: "https://github.com/Swinject/Swinject", requirement: .upToNextMajor(from: "2.7.1"))
    static let Nimble = Package.remote(url: "https://github.com/Quick/Nimble", requirement: .upToNextMajor(from: "9.2.0"))
    static let Quick = Package.remote(url: "https://github.com/Quick/Quick", requirement: .upToNextMajor(from: "4.0.0"))
    
    // local spm
    static let ResourcePackage = Package.local(path: .relativeToRoot("Projects/Modules/ResourcePackage"))
    static let Logger = Package.local(path: .relativeToRoot("Projects/Modules/ThirdPartyManager/LocalSPM/Logger"))
}
