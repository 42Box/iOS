//
//  OAuth.swift
//  iBox
//
//  Created by Chan on 3/10/24.
//

import Foundation

final class OAuthAPI {
    static let shared = OAuthAPI()
    
    private var clientId: String?
    private var clientSecret: String?
    private var redirectURI: String?
    private var responseType: String?
    var oauthCallbackCode: String?
    
    private init() {
        let configurations = loadConfigurations()
        self.clientId = configurations.clientID
        self.clientSecret = configurations.clientSecret
        self.redirectURI = configurations.redirectURI
        self.responseType = "code"
    }
    
    private func loadConfigurations() -> (clientID: String?, clientSecret: String?, redirectURI: String?) {
        var clientID: String?
        var clientSecret: String?
        var redirectURI: String?
        
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path) {
            clientID = config["ClientID"] as? String
            clientSecret = config["ClientSecret"] as? String
            redirectURI = config["RedirectURI"] as? String
        }
        
        return (clientID, clientSecret, redirectURI)
    }
    
    func createAuthURL() -> URL? {
        var components = URLComponents(string: "https://api.intra.42.fr/oauth/authorize")
        
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: responseType),
        ]
        
        guard let url = components?.url else {
            print("Invalid URL")
            return nil
        }
        
        return url
    }
    
    private func createTokenExchangeParameters(code: String) -> (contentLength: String, content: Data?) {
        let parameters: [String: String] = [
            "grant_type": "authorization_code",
            "client_id": clientId ?? "",
            "client_secret": clientSecret ?? "",
            "code": code,
            "redirect_uri": redirectURI ?? ""
        ]
        let paramData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        return (String(paramData.count), paramData)
    }

    func exchangeCodeForToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "https://api.intra.42.fr/oauth/token")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let paramData = createTokenExchangeParameters(code: code)
        request.setValue(paramData.contentLength, forHTTPHeaderField: "Content-Length")
        request.httpBody = paramData.content

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }

            completion(self.processTokenExchangeResponse(data))
        }
        
        task.resume()
    }
    
    private func processTokenExchangeResponse(_ data: Data) -> Result<String, Error> {
        do {
            if let accessToken = String(data: data, encoding: .utf8) {
                return .success(accessToken)
            } else {
                throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not decode token"])
            }
        } catch {
            return .failure(error)
        }
    }
}
