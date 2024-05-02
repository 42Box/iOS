import ProjectDescription

// MARK: - Project Factory

protocol ProjectFactory {
    var projectName: String { get }
    var dependencies: [TargetDependency] { get }
    
    func generateTarget() -> [Target]
}

// MARK: - Plist.Value Extension
extension Plist.Value {
    static var displayName: Plist.Value = "42Box"
    static var displayShareExtensionName: Plist.Value = "42Box.Share"
    static var appVersion: Plist.Value = "1.0.1"
    
}

// MARK: - iBox Factory

class iBoxFactory: ProjectFactory {
    let projectName: String = "iBox"
    let bundleId: String = "com.box42.iBox"
    let iosVersion: String = "15.0"
    
    let dependencies: [TargetDependency] = [
        .external(name: "SnapKit"),
        .external(name: "SwiftSoup"),
        .external(name: "SkeletonView"),
        .target(name: "iBoxShareExtension")
    ]
    
    let iBoxShareExtensionDependencies: [TargetDependency] = [
        .external(name: "SnapKit")
    ]
    
    private let appInfoPlist: [String: Plist.Value] = [
        "ITSAppUsesNonExemptEncryption": false,
        "CFBundleDisplayName": Plist.Value.displayName,
        "CFBundleName": "iBox",
        "CFBundleShortVersionString": Plist.Value.appVersion,
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
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoadsInWebContent": true
        ]
    ]
    
    private let shareExtensionInfoPlist: [String: Plist.Value] = [
        "CFBundleDisplayName": Plist.Value.displayShareExtensionName,
        "CFBundleShortVersionString": Plist.Value.appVersion,
        "CFBundleVersion": "1",
        "NSExtension": [
            "NSExtensionAttributes": [
                "NSExtensionActivationRule": [
                    "NSExtensionActivationSupportsWebPageWithMaxCount": 1,
                    "NSExtensionActivationSupportsWebURLWithMaxCount": 1,
                    "SUBQUERY": [
                        "extensionItems": [
                            "SUBQUERY": [
                                "attachments": [
                                    "ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO 'public.data'": "TRUE"
                                ],
                                "@count": 1
                            ]
                        ],
                        "@count": 1
                    ]
                ]
            ],
            "NSExtensionPointIdentifier": "com.apple.share-services",
            "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).CustomShareViewController"
        ]
    ]
    
    func generateTarget() -> [ProjectDescription.Target] {
        let appTarget = Target(
            name: projectName,
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS(iosVersion),
            infoPlist: .extendingDefault(with: appInfoPlist),
            sources: ["\(projectName)/Sources/**"],
            resources: "\(projectName)/Resources/**",
            dependencies: dependencies
        )
        
        let shareExtensionTarget = Target(
            name: "\(projectName)ShareExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).ShareExtension",
            deploymentTargets: .iOS(iosVersion),
            infoPlist: .extendingDefault(with: shareExtensionInfoPlist),
            sources: ["ShareExtension/Sources/**"],
            resources: ["ShareExtension/Resources/**"],
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
