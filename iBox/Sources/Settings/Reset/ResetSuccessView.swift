//
//  ResetSuccessView.swift
//  iBox
//
//  Created by Chan on 4/17/24.
//

import UIKit

import SnapKit

protocol ResetSuccessViewDelegate: AnyObject {
    func didCompleteReset()
}

class ResetSuccessView: UIView {
    
    weak var delegate: ResetSuccessViewDelegate?
    
    private let checkMarkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .box2
    }
    
    private let label = UILabel().then {
        $0.text = "초기화 성공"
        $0.textColor = .invertBackgroundColor
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private let backPannelView = UIView().then {
        $0.backgroundColor = .backgroundColor
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        animateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.alpha = 0
        self.backgroundColor = UIColor.invertBackgroundColor.withAlphaComponent(0.35)
        self.addSubview(backPannelView)
        backPannelView.addSubview(stackView)
        
        stackView.addArrangedSubview(checkMarkImageView)
        stackView.addArrangedSubview(label)
        
        backPannelView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.center.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        checkMarkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
    }
    
    private func animateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.backPannelView.alpha = 1.0
            }
            
            UIView.animate(withDuration: 0.5, delay: 2, options: []) {
                self.backPannelView.alpha = 0.0
            } completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.alpha = 0.0
                }) { _ in
                    self.removeFromSuperview()
                    self.delegate?.didCompleteReset()
                }
            }
        }
    }
}
