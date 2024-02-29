//
//  SceneDelegate.swift
//  iBox
//
//  Created by 김찬희 on 2023/12/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        // 앱 테마 정보
        window?.overrideUserInterfaceStyle = window?.toUserInterfaceStyle(UserDefaultsManager.theme) ?? .unspecified
        
        insertDefaultDataIfNeeded()
        
        // 나중에 userDefaults에 저장해두고 꺼내와서 preload하기
        let urlsToPreload = [
            URL(string: "https://profile.intra.42.fr/")!,
            URL(string: "https://www.where42.kr/")!,
            URL(string: "https://stat.42seoul.kr/")!,
            URL(string: "https://42library.kr/")!,
            URL(string: "https://cabi.42seoul.io/")!,
            URL(string: "https://24hoursarenotenough.42seoul.kr/")!
        ]
        WebViewPreloader.shared.preload(urls: urlsToPreload)
        
        let favorite = UserDefaultsManager.favorite
        let favoriteUrl = favorite.url
        WebViewPreloader.shared.preloadFavoriteView(url: favoriteUrl)
                
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible() // 윈도우를 화면에 보여줌

        if let urlContext = connectionOptions.urlContexts.first {
            let url = urlContext.url
            guard url.scheme == "iBox" else { return }

            print("Opened URL: \(url)")
            
            // 앱이 실행되기 전에 url이 들어오는 경우 Logic
        }
    }
    
    private func insertDefaultDataIfNeeded() {
        let isDefaultDataInserted = UserDefaultsManager.isDefaultDataInserted
        if !isDefaultDataInserted {
            var defaultData = [
                Folder(id: UUID(), name: "42 폴더", color: .gray, bookmarks: [
                    Bookmark(id: UUID(), name: "42 Intra", url: URL(string: "https://profile.intra.42.fr/")!),
                    Bookmark(id: UUID(), name: "42Where", url: URL(string: "https://www.where42.kr/")! ),
                    Bookmark(id: UUID(), name: "42Stat", url: URL(string: "https://stat.42seoul.kr/")!),
                    Bookmark(id: UUID(), name: "집현전", url: URL(string: "https://42library.kr/")!),
                    Bookmark(id: UUID(), name: "Cabi", url: URL(string: "https://cabi.42seoul.io/")!),
                    Bookmark(id: UUID(), name: "24HANE", url: URL(string: "https://24hoursarenotenough.42seoul.kr/")!)
                ])
            ]
            CoreDataManager.shared.deleteAllFolders()
            CoreDataManager.shared.addInitialFolders(defaultData)
            UserDefaultsManager.isDefaultDataInserted = true
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {
            let url = urlContext.url
            guard url.scheme == "iBox" else { return }

            print("Opened URL: \(url)")
            
            // 앱 실행 중에 url이 들어오는 경우 Logic
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}

