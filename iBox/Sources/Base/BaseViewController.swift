//
//  BaseViewController.swift
//  iBox
//
//  Created by jiyeon on 1/3/24.
//

import UIKit

import SnapKit

class NavigationBar: UIView {
    var backButton = UIButton()
    var titleLabel = UILabel()
    var addButton = UIButton()
    var moreButton = UIButton()
}

protocol BaseViewControllerProtocol {
    func setupNavigationBar()
}

class BaseViewController<View: UIView>: UIViewController {
    
    let backgroundColor: UIColor = .backgroundColor
    let tintColor: UIColor = .label
    let titleFont: UIFont = .systemFont(ofSize: 20, weight: .semibold)
    
    // MARK: - UI Components
    
    let statusBar = UIView()
    
    let navigationBar = NavigationBar().then {
        $0.backButton.configuration = .plain()
        $0.backButton.configuration?.image = UIImage(systemName: "chevron.left")
        $0.backButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .bold)
        $0.addButton.configuration = .plain()
        $0.addButton.configuration?.image = UIImage(systemName: "plus")
        $0.addButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .bold)
        $0.moreButton.configuration = .plain()
        $0.moreButton.configuration?.image = UIImage(systemName: "ellipsis.circle")
        $0.moreButton.configuration?.preferredSymbolConfigurationForImage = .init(weight: .bold)
    }
    
    let contentView: UIView = View()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setupProperty()
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        view.backgroundColor = .backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setNavigationBarTintColor(tintColor)
        setNavigationBarTitleLabelFont(titleFont)
        setNavigationBarBackButtonHidden(true)
        setNavigationBarMenuButtonHidden(true)
        
        navigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        view.addSubview(statusBar)
        view.addSubview(navigationBar)
        navigationBar.addSubview(navigationBar.backButton)
        navigationBar.addSubview(navigationBar.titleLabel)
        navigationBar.addSubview(navigationBar.addButton)
        navigationBar.addSubview(navigationBar.moreButton)
        view.addSubview(contentView)
    }
    
    private func setupLayout() {
        statusBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(statusBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        navigationBar.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        navigationBar.titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        navigationBar.moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        navigationBar.addButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar.moreButton.snp.leading).offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(statusBar.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
    
    // MARK: - BaseViewController
    
    func setNavigationBarBackgroundColor(_ color: UIColor?) {
        statusBar.backgroundColor = color
        navigationBar.backgroundColor = color
    }
    
    func setNavigationBarTintColor(_ color: UIColor) {
        navigationBar.backButton.tintColor = color
        navigationBar.addButton.tintColor = color
        navigationBar.moreButton.tintColor = color
    }
    
    func setNavigationBarHidden(_ hidden: Bool) {
        navigationBar.isHidden = hidden
        
        if hidden {
            contentView.snp.remakeConstraints { make in
                make.top.equalTo(statusBar.snp.bottom)
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalToSuperview()
            }
        } else {
            contentView.snp.remakeConstraints { make in
                make.top.equalTo(statusBar.snp.bottom).offset(60)
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    func setNavigationBarBackButtonHidden(_ hidden: Bool) {
        navigationBar.backButton.isHidden = hidden
        
        if hidden {
            navigationBar.titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(30)
                make.centerY.equalToSuperview()
            }
        } else {
            navigationBar.titleLabel.snp.remakeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    func setNavigationBarMenuButtonHidden(_ hidden: Bool) {
        navigationBar.addButton.isHidden = hidden
        navigationBar.moreButton.isHidden = hidden
    }
    
    func setNavigationBarAddButtonAction(_ selector: Selector) {
        navigationBar.addButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    func setNavigationBarMoreButtonAction(_ selector: Selector) {
        navigationBar.moreButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    func setNavigationBarTitleLabelText(_ text: String?) {
        navigationBar.titleLabel.text = text
    }
    
    func setNavigationBarTitleLabelFont(_ font: UIFont?) {
        navigationBar.titleLabel.font = font
    }
    
    func setNavigationBarTitleLabelTextColor(_ color: UIColor?) {
        navigationBar.titleLabel.textColor = color
    }
    
    // MARK: - Action Functions
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
