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
    
    let messageLabel = UILabel()
    
    let backButton = UIButton()
    let retryButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
        changeImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        retryButton.setTitle("무시하기", for: .normal)
        retryButton.backgroundColor = .systemBlue
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.layer.cornerRadius = 10
        
        addSubview(messageLabel)
        addSubview(retryButton)
        
        for imageName in images {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true
            imageView.tintColor = .box2
            addSubview(imageView)
            imageViews.append(imageView)
        }
        
        changeImages()
        
    }
    
    private func setupLayout() {
        
        imageViews.forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
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
    }
    
    func configure(with error: Error, url: String) {
        messageLabel.text = "\(url): \n해당 주소를 불러오는데 실패했어요!"
        print(error.localizedDescription)
    }
    
    private func changeImages() {
        var currentIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            let state = AppStateManager.shared.isVersionCheckCompleted
            if state == .success || state == .later || state == .maxRetryReached {
                timer.invalidate()
                self.timer = nil
                return
            }
            
            self.imageViews.forEach { $0.isHidden = true }
            self.imageViews[currentIndex].isHidden = false
            
            currentIndex = (currentIndex + 1) % self.imageViews.count
        }
    }
}
