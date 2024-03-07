//
//  CustomLaunchScreenView.swift
//  iBox
//
//  Created by Chan on 3/2/24.
//

import UIKit

import SnapKit

class CustomLaunchScreenView: UIView {
    private let logoImageView = UIImageView()
    private var imageViews: [UIImageView] = []
    private let images = ["fox_page0", "fox_page1", "fox_page2", "fox_page3", "fox_page4"]
    private var timer: Timer?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .box2
        
        logoImageView.image = UIImage(named: "1024")
        logoImageView.contentMode = .scaleAspectFit
        addSubview(logoImageView)
        
        for imageName in images {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.isHidden = true
            imageView.tintColor = .white
            addSubview(imageView)
            imageViews.append(imageView)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        imageViews.forEach { imageView in
            imageView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(20)
                make.left.equalToSuperview().inset(20)
                make.width.height.equalTo(32)
            }
        }
        
        changeImages()
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
