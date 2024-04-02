//
//  CustomLaunchScreenViewController.swift
//  iBox
//
//  Created by Chan on 3/2/24.
//

import UIKit
import Combine

class CustomLaunchScreenViewController: UIViewController {
    private var customLaunchScreenView: CustomLaunchScreenView!
    private var cancellables: Set<AnyCancellable> = []
    private var urlContext: UIOpenURLContext?
    
    init(urlContext: UIOpenURLContext?) {
        self.urlContext = urlContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLaunchScreenView()
        observeVersionCheckCompletion()
    }
    
    private func configureLaunchScreenView() {
        customLaunchScreenView = CustomLaunchScreenView(frame: self.view.bounds)
        self.view.addSubview(customLaunchScreenView)
        
        customLaunchScreenView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Custom Update Checker View (예정)
    private func observeVersionCheckCompletion() {
        AppStateManager.shared.$isVersionCheckCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success, .maxRetryReached, .later:
                    self?.transitionToNextScreen()
                case .urlError:
                    print("URL 에러가 발생했습니다.")
                case .networkError:
                    print("네트워크 요청에 실패했습니다.")
                case .decodingError:
                    print("응답 디코딩에 실패했습니다.")
                case .versionOutdated(let mandatoryUpdate, let updateUrl):
                    if mandatoryUpdate {
                        print("필수 업데이트가 필요합니다. 업데이트 URL: \(updateUrl)")
                    } else {
                        print("업데이트가 있습니다. 업데이트 URL: \(updateUrl)")
                    }
                case .serverError:
                    print("서버 에러 또는 기타 에러가 발생했습니다.")
                case .update:
                    print("업데이트 클릭")
                case .internalSceneError:
                    print("scene error 수집")
                case .internalInfoError:
                    print("info error 수집")
                case .Initial:
                    print("초기값")
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func transitionToNextScreen() {
        guard let window = self.view.window else { return }
        
        let mainViewController = MainTabBarController()
        window.rootViewController = mainViewController
        
        if let urlContext = self.urlContext,
           let tabBarController = window.rootViewController as? UITabBarController {
            URLDataManager.shared.navigateToAddBookmarkView(from: urlContext.url, in: tabBarController)
        }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {}, completion: nil)
    }
}
