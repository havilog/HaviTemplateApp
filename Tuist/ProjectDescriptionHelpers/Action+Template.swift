import ProjectDescription

public extension TargetAction {
    static let swiftlint = TargetAction.pre(
        path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"), 
        name: "SwiftLint"
    )
}
