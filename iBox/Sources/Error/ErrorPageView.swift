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
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private let problemUrlLabel = UILabel().then {
        $0.font = .cellTitleFont
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let messageLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "해당 주소에서 문제가 발생했습니다."
        $0.font = .boldLabelFont
    }
    
    let closeButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.attributedTitle = .init(
            "닫기",
            attributes: .init([.font: UIFont.boldLabelFont, .foregroundColor: UIColor.white])
        )
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 10
        $0.addAnimationForStateChange(from: .box, to: .systemGray)
    }
    
    let retryButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.attributedTitle = .init(
            "새로고침",
            attributes: .init([.font: UIFont.boldLabelFont, .foregroundColor: UIColor.white])
        )
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemGray
        $0.layer.cornerRadius = 10
        $0.addAnimationForStateChange(from: .box, to: .systemGray)
    }
    
    let backButton = UIButton().then {
        $0.configuration = .plain()
        $0.configuration?.attributedTitle = .init(
            "나가기",
            attributes: .init([.font: UIFont.boldLabelFont, .foregroundColor: UIColor.white])
        )
        $0.backgroundColor = .box2
        $0.layer.cornerRadius = 10
        $0.addAnimationForStateChange(from: .box, to: .box2)
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
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
    
    private func setupProperty() {
        changeImages()
    }
    
    private func setupHierarchy() {
        addSubview(backPannelView)
        backPannelView.addSubview(messageLabel)
        backPannelView.addSubview(problemUrlLabel)
        backPannelView.addSubview(stackView)
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(retryButton)
        stackView.addArrangedSubview(closeButton)
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
                make.bottom.equalTo(backPannelView.snp.top).offset(5)
                make.width.height.equalTo(38)
            }
        }
        
        backPannelView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        problemUrlLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.bottom.equalTo(messageLabel.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(20)
        }
        
        [backButton, retryButton, closeButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
    }
    
    func configure(with error: Error, url: String) {
        problemUrlLabel.text = "\(url)"
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
