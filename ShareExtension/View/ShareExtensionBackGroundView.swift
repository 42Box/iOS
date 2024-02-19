//
//  BackGroundView.swift
//  iBox
//
//  Created by Chan on 2/19/24.
//

import UIKit
import SnapKit

protocol ShareExtensionBackGroundViewDelegate: AnyObject {
    func didTapCancel()
    func didTapSave()
    func didTapOpenApp()
}

class ShareExtensionBackGroundView: UIView {
    weak var delegate: ShareExtensionBackGroundViewDelegate?
    
    let label = UILabel()
    let cancelButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let openAppButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        setupLabel()
        setupCancelButton()
        setupSaveButton()
        setupOpenAppButton()
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        openAppButton.addTarget(self, action: #selector(openAppButtonTapped), for: .touchUpInside)
    }
    
    private func setupLabel() {
        self.addSubview(label)
        label.text = "Exporting links to iBox!"
        label.textColor = .black
        label.textAlignment = .center
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(21)
        }
    }
    
    private func setupCancelButton() {
        self.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    private func setupSaveButton() {
        self.addSubview(saveButton)
        saveButton.setTitle("Send to iBox app", for: .normal)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    private func setupOpenAppButton() {
        self.addSubview(openAppButton)
        openAppButton.setTitle("Open in the iBox app", for: .normal)
        
        openAppButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    func updateLabel(with text: String) {
        label.text = text
    }
    
    // MARK: - Actions
    
    @objc func cancelButtonTapped() {
        delegate?.didTapCancel()
    }
    
    @objc func saveButtonTapped() {
        delegate?.didTapSave()
    }
    
    @objc func openAppButtonTapped() {
        delegate?.didTapOpenApp()
    }
}
