import ProjectDescription

// MARK: - Project Factory

protocol ProjectFactory {
    var projectName: String { get }
    var dependencies: [TargetDependency] { get }
    
    func generateTarget() -> [Target]
}

// MARK: - iBox Factory

class iBoxFactory: ProjectFactory {
    let projectName: String = "iBox"
    let bundleId: String = "com.box42.iBox"
    
    let dependencies: [TargetDependency] = [
        .external(name: "SnapKit")
    ]
    
    let infoPlist: [String: Plist.Value] = [
        "ITSAppUsesNonExemptEncryption": false,
        "CFBundleName": "iBox",
        "CFBundleShortVersionString": "1.2.1",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ]
    ]
    
    func generateTarget() -> [ProjectDescription.Target] {[
        Target(
            name: projectName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(projectName)/Sources/**"],
            resources: "\(projectName)/Resources/**",
            dependencies: dependencies
        )
    ]}
    
    
}

// MARK: - Project

let factory = iBoxFactory()

let project: Project = .init(
    name: factory.projectName,
    targets: factory.generateTarget()
)
