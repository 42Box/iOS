//
//  VersioningHandler.swift
//  iBox
//
//  Created by Chan on 3/2/24.
//

import UIKit

class VersioningHandler {
    
    func checkAppVersion() {
        let urlString = "https://my-json-server.typicode.com/42Box/versioning/db"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let versionInfo = try JSONDecoder().decode(VersionInfo.self, from: data)
                guard let latestVersion = versionInfo.version.first?.latestVersion,
                      let minRequiredVersion = versionInfo.version.first?.minRequiredVersion,
                      let updateUrl = versionInfo.url.updateURL else { return }
                
                DispatchQueue.main.async {
                    self?.compareVersion(latestVersion: latestVersion, minRequiredVersion: minRequiredVersion, updateUrl: updateUrl)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func compareVersion(latestVersion: String, minRequiredVersion: String, updateUrl: String) {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        if appVersion.compare(minRequiredVersion, options: .numeric) == .orderedAscending {
            showAlertForUpdate(updateUrl: updateUrl, isMandatory: true)
        } else if appVersion.compare(latestVersion, options: .numeric) == .orderedAscending {
            showAlertForUpdate(updateUrl: updateUrl, isMandatory: false)
        }
    }
    
    
    func showAlertForUpdate(updateUrl: String, isMandatory: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        
        
        let message = isMandatory ? "새로운 버전이 필요합니다. 업데이트 하시겠습니까?" : "새로운 버전이 있습니다. 업데이트 하시겠습니까?"
        let alert = UIAlertController(title: "업데이트 알림", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { _ in
            if let url = URL(string: updateUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        
        if !isMandatory {
            alert.addAction(UIAlertAction(title: "나중에", style: .cancel))
        }
        
        rootViewController.present(alert, animated: true)
    }
}
