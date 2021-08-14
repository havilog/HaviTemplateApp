import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "CoreKit",
    dependencies: [
        .networkModule,
        .databaseModule,
        .utilityModule,
        .thirdPartyManager,
    ]
)
