import ProjectDescription
//import UtilityPlugin

public extension Project {
    static func staticLibrary(
        name: String,
        platform: Platform = .iOS,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        customSettings: [String: SettingValue] = [:]
    ) -> Self {
        return project(
            name: name,
            packages: packages,
            product: .staticLibrary,
            platform: platform,
            dependencies: dependencies,
            customSettings: customSettings
        )
    }
    
    static func staticFramework(
        name: String,
        platform: Platform = .iOS,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        customSettings: [String: SettingValue] = [:]
    ) -> Self {
        return project(
            name: name,
            packages: packages,
            product: .staticFramework,
            platform: platform,
            dependencies: dependencies,
            customSettings: customSettings
        )
    }
    
    static func framework(
        name: String,
        platform: Platform = .iOS,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        customSettings: [String: SettingValue] = [:]
    ) -> Self {
        return project(
            name: name,
            packages: packages,
            product: .framework,
            platform: platform,
            dependencies: dependencies,
            customSettings: customSettings
        )
    }
}

/*
 만약 배포 버전에 문제가 생긴다면 settings 안에 다음 코드 추가
 base: [
     !프로젝트 버전 번호, 마케팅 버전 번호는 Info.plist를 통해서 설정!
     .marketVersion: "1.1",
     .currentProjectVersion: "2"
 ],
 */
public extension Project {
    static func project(
        name: String,
        organizationName: String = "havi",
        packages: [Package] = [],
        product: Product,
        platform: Platform = .iOS,
        deploymentTarget: DeploymentTarget? = .defaultDeployment,
        actions: [TargetAction] = [],
        dependencies: [TargetDependency] = [],
        customSettings: [String: SettingValue] = [:],
        infoPlist: InfoPlist = .default,
        settings: Settings? = nil,
        schemes: [Scheme] = []
    ) -> Self {
        var base: SettingsDictionary = [
            .codeSignIdentity: "Apple Development",
            .codeSigningStyle: "Automatic",
            .developmentTeam: "85329TR25G",
            .codeSigningRequired: "NO"
        ]
        
        customSettings.forEach {
            base.updateValue($1, forKey: $0)
        }
        
        let settings = Settings(
            base: base,
            configurations: [
                .debug(name: "Debug", settings: [
                    .bundleIdentifier: "com.\(organizationName).\(name)",
                    .bundleName: "\(name)_Dev"
                ]),
                .debug(name: "AdHoc", settings: [
                    .bundleIdentifier: "com.\(organizationName).\(name)",
                    .bundleName: "\(name)_AdHoc"
                ]),
                .release(name: "Release", settings: [
                    .bundleIdentifier: "com.\(organizationName).\(name)",
                    .bundleName: "\(name)_Dist"
                ])
            ]
        )
        
        let mainTarget: Target = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "com.\(organizationName).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            actions: actions,
            dependencies: dependencies
        )
        
        let testTarget: Target = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "com.\(organizationName).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: name),
                .SPM.Quick,
                .SPM.Nimble,
            ]
        )
        
        let targets: [Target] = [
            mainTarget,
            testTarget
        ]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages + [.Quick, .Nimble],
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}
