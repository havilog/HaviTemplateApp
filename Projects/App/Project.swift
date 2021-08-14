import ProjectDescription
import ProjectDescriptionHelpers

let actions: [TargetAction] = [.swiftlint]

let projectName: String = "HaviTemplateApp"
let organization: String = "havi"

let schemes = [
    Scheme(
        name: "\(projectName)-AdHoc",
        shared: true,
        buildAction: BuildAction(targets: ["\(projectName)"]),
        testAction: TestAction(
            targets: ["\(projectName)Tests"],
            configurationName: "AdHoc",
            coverage: true
        ),
        runAction: RunAction(configurationName: "AdHoc"),
        archiveAction: ArchiveAction(configurationName: "AdHoc"),
        profileAction: ProfileAction(configurationName: "AdHoc"),
        analyzeAction: AnalyzeAction(configurationName: "AdHoc")
    ),
    Scheme(
        name: "\(projectName)-Release",
        shared: true,
        buildAction: BuildAction(targets: ["\(projectName)"]),
        testAction: TestAction(
            targets: ["\(projectName)Tests"],
            configurationName: "Release",
            coverage: true
        ),
        runAction: RunAction(configurationName: "Release"),
        archiveAction: ArchiveAction(configurationName: "Release"),
        profileAction: ProfileAction(configurationName: "Release"),
        analyzeAction: AnalyzeAction(configurationName: "Release")
    ),
]

let project = Project.project(
    name: projectName,
    organizationName: organization,
    product: .app,
    actions: actions,
    dependencies: [
        .features
    ],
    infoPlist: "Supporting/Info.plist",
    schemes: schemes
)
