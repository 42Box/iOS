//
//  OAuthManager.swift
//  iBox
//
//  Created by Chan on 3/10/24.
//

import AuthenticationServices

final class OAuthManager: NSObject {
    var authSession: ASWebAuthenticationSession?
    
    func startAuth() {
        guard let authURL = OAuthAPI.shared.createAuthURL() else {
            print("Invalid Auth URL")
            return
        }
        
        let callbackURLScheme = "iBox"
        self.authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: callbackURLScheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else {
                print("Authentication session error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard let code = self.extractCode(from: callbackURL) else {
                print("Failed to extract authorization code")
                return
            }
            
            OAuthAPI.shared.exchangeCodeForToken(code: code) { result in
                switch result {
                case .success(let accessToken):
                    print("Access Token: \(accessToken)")
                case .failure(let error):
                    print("Error exchanging code for token: \(error.localizedDescription)")
                }
            }
        }
        
        presentationContextProviderConfig()
    }
    
    private func extractCode(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "code" })?.value
    }
}

extension OAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            fatalError("Active UIWindowScene not found")
        }
        
        guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("Key window not found")
        }
        
        return window
    }
    
    private func presentationContextProviderConfig() {
        self.authSession?.presentationContextProvider = self
        self.authSession?.start()
    }
}
