//
//  VersioningHandler.swift
//  iBox
//
//  Created by Chan on 3/2/24.
//

import UIKit

class VersioningHandler {
    
    func checkAppVersion(retryCount: Int = 0, completion: @escaping (VersionCheckCode) -> Void) {
        let maxRetryCount = 3
        let urlString = "https://my-json-server.typicode.com/42Box/versioning/db"
        guard let url = URL(string: urlString) else {
            completion(.urlError)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                if retryCount < maxRetryCount {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.checkAppVersion(retryCount: retryCount + 1, completion: completion)
                    }
                } else {
                    completion(.maxRetryReached)
                }
                return
            }
            
            do {
                let versionInfo = try JSONDecoder().decode(VersionInfo.self, from: data)
                guard let latestVersion = versionInfo.version.first?.latestVersion,
                      let minRequiredVersion = versionInfo.version.first?.minRequiredVersion,
                      let updateUrl = versionInfo.url.updateURL else {
                    completion(.urlError)
                    return
                }
                
                self.compareVersion(latestVersion: latestVersion, minRequiredVersion: minRequiredVersion, updateUrl: updateUrl, completion: completion)
            } catch {
                completion(.decodingError)
            }
        }
        
        task.resume()
    }
    
    func compareVersion(latestVersion: String, minRequiredVersion: String, updateUrl: String, completion: @escaping (VersionCheckCode) -> Void) {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            completion(.internalInfoError)
            return
        }
        
        if appVersion.compare(minRequiredVersion, options: .numeric) == .orderedAscending {
            showAlertForUpdate(updateUrl: updateUrl, isMandatory: true, completion: completion)
        } else if appVersion.compare(latestVersion, options: .numeric) == .orderedAscending {
            showAlertForUpdate(updateUrl: updateUrl, isMandatory: false, completion: completion)
        } else {
            completion(.success)
        }
    }
    
    func showAlertForUpdate(updateUrl: String, isMandatory: Bool, completion: @escaping (VersionCheckCode) -> Void) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
                  let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                completion(.internalSceneError)
                return
            }
            
            let message = isMandatory ? "새로운 버전이 필요합니다. 업데이트 하시겠습니까?" : "새로운 버전이 있습니다. 업데이트 하시겠습니까?"
            let alert = UIAlertController(title: "업데이트 알림", message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { _ in
                if let url = URL(string: updateUrl), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    completion(.update)
                }
            }))
            
            if !isMandatory {
                alert.addAction(UIAlertAction(title: "나중에", style: .cancel, handler: { _ in
                    completion(.later)
                }))
            }
            
            rootViewController.present(alert, animated: true)
        }
    }
}
