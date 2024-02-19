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
    let iosVersion: String = "15.0"
    
    let dependencies: [TargetDependency] = [
        .external(name: "SnapKit"),
        .target(name: "iBoxShareExtension")
    ]
    
    let iBoxShareExtensionDependencies: [TargetDependency] = [
        .external(name: "SnapKit")
    ]
    
    private let appInfoPlist: [String: Plist.Value] = [
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
        ],
        "CFBundleURLTypes": [
            [
                "CFBundleURLName": "com.url.iBox",
                "CFBundleURLSchemes": ["iBox"],
                "CFBundleTypeRole": "Editor"
            ]
        ],
    ]
    
    private let shareExtensionInfoPlist: [String: Plist.Value] = [
        "CFBundleDisplayName": "iBox.Share",
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "NSExtension": [
            "NSExtensionAttributes": [
                "NSExtensionActivationRule": [
                    "NSExtensionActivationSupportsWebPageWithMaxCount" : 1,
                    "NSExtensionActivationSupportsWebURLWithMaxCount" : 1
                ]
            ],
            "NSExtensionPointIdentifier": "com.apple.share-services",
            "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).CustomShareViewController"
        ]
    ]
    
    func generateTarget() -> [ProjectDescription.Target] {
        let appTarget = Target(
            name: projectName,
            platform: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
            infoPlist: .extendingDefault(with: appInfoPlist),
            sources: ["\(projectName)/Sources/**"],
            resources: "\(projectName)/Resources/**",
            dependencies: dependencies
        )
        
        let shareExtensionTarget = Target(
            name: "\(projectName)ShareExtension",
            platform: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).ShareExtension",
            deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
            infoPlist: .extendingDefault(with: shareExtensionInfoPlist),
            sources: ["ShareExtension/**"],
            resources: [],
            dependencies: iBoxShareExtensionDependencies
        )
        
        return [appTarget, shareExtensionTarget]
    }
    
}

// MARK: - Project

let factory = iBoxFactory()

let project: Project = .init(
    name: factory.projectName,
    targets: factory.generateTarget()
)
