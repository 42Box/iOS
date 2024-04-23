//
//  ErrorPageView.swift
//  iBox
//
//  Created by Chan on 4/18/24.
//

import UIKit

import SnapKit

class ErrorPageView: UIView {
    private var imageViews: [UIImageView] = []
    private let images = ["fox_page0", "fox_page1", "fox_page2", "fox_page3", "fox_page4"]
    private var timer: Timer?
    
    private let backPannelView = UIView().then {
        $0.backgroundColor = .backgroundColor
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let backButton = UIButton().then {
        $0.setTitle("나가기", for: .normal)
        $0.backgroundColor = .box2
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    private let retryButton = UIButton().then {
        $0.setTitle("새로고침", for: .normal)
        $0.backgroundColor = .box2
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    private let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.backgroundColor = .box2
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupAnimation()
        setupLayout()
        changeImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProperty() {
        backgroundColor = .clear
        
        changeImages()
    }
    
    private func setupHierarchy() {
        addSubview(messageLabel)
        addSubview(retryButton)
        addSubview(closeButton)
        addSubview(backButton)
    }
    
    private func setupAnimation() {
        for imageName in images {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true
            imageView.tintColor = .box2
            addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    private func setupLayout() {
        
        imageViews.forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.3)
                make.leading.greaterThanOrEqualToSuperview().offset(20)
                make.trailing.lessThanOrEqualToSuperview().offset(-20)
                make.width.height.equalTo(32)
            }
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageViews[0].snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }

        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }

        closeButton.snp.makeConstraints { make in
            make.leading.equalTo(retryButton.snp.trailing).offset(20)
            make.centerY.equalTo(retryButton.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }

        backButton.snp.makeConstraints { make in
            make.trailing.equalTo(retryButton.snp.leading).offset(-20)
            make.centerY.equalTo(retryButton.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
    }
    
    func configure(with error: Error, url: String) {
        messageLabel.text = "\(url)\n해당 주소에서 문제가 발생했습니다."
        print(error.localizedDescription)
    }
    
    private func changeImages() {
        var currentIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            let state = AppStateManager.shared.currentViewErrorState
            
            if state == .normal {
                return
            }
            
            self.imageViews.forEach { $0.isHidden = true }
            self.imageViews[currentIndex].isHidden = false
            
            currentIndex = (currentIndex + 1) % self.imageViews.count
        }
    }
}
