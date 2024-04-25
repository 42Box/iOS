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
    var timer: Timer?
    
    private let backPannelView = UIView().then {
        $0.backgroundColor = .backgroundColor
    }
    
    private let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let problemLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "해당 주소에서 문제가 발생했습니다."
    }
    
    let backButton = UIButton().then {
        $0.setTitle("나가기", for: .normal)
        $0.backgroundColor = .box2
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addAnimationForStateChange(from: .box, to: .box2)
    }
    
    let retryButton = UIButton().then {
        $0.setTitle("새로고침", for: .normal)
        $0.backgroundColor = .systemGray
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addAnimationForStateChange(from: .box, to: .systemGray)
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.backgroundColor = .systemGray
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addAnimationForStateChange(from: .box, to: .systemGray)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperty()
        setupHierarchy()
        setupAnimation()
        setupLayout()
        changeImages()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview == nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backPannelView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
    }
    
    private func setupProperty() {
        changeImages()
    }
    
    private func setupHierarchy() {
        addSubview(backPannelView)
        backPannelView.addSubview(retryButton)
        backPannelView.addSubview(closeButton)
        backPannelView.addSubview(backButton)
        backPannelView.addSubview(problemLabel)
        backPannelView.addSubview(messageLabel)
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
        
        backPannelView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        retryButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
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
        
        problemLabel.snp.makeConstraints { make in
            make.bottom.equalTo(retryButton.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(problemLabel.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        imageViews.forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(safeAreaLayoutGuide).offset(10)
                make.bottom.equalTo(messageLabel.snp.top).offset(-10)
                make.leading.greaterThanOrEqualToSuperview().offset(20)
                make.trailing.lessThanOrEqualToSuperview().offset(-20)
                make.width.height.equalTo(32)
            }
        }
    }
    
    func configure(with error: Error, url: String) {
        messageLabel.text = "\(url)"
        print(error.localizedDescription)
    }
    
    private func changeImages() {
        var currentIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
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
