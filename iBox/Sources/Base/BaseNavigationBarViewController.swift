//
//  BaseNavigationBarViewController.swift
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

protocol BaseNavigationBarViewControllerProtocol {
    var statusBar: UIView { get }
    var navigationBar: NavigationBar { get }
    var contentView: BaseView { get }
    
    func setupNavigationBar()
    func setNavigationBarBackgroundColor(_ color: UIColor?)
    func setNavigationBarTintColor(_ color: UIColor)
    func setNavigationBarHidden(_ hidden: Bool)
    func setNavigationBarBackButtonHidden(_ hidden: Bool)
    func setNavigationBarMenuButtonHidden(_ hidden: Bool)
    func setNavigationBarAddButtonAction(_ selector: Selector)
    func setNavigationBarMoreButtonAction(_ selector: Selector)
    func setNavigationBarTitleLabelText(_ text: String?)
    func setNavigationBarTitleLabelFont(_ font: UIFont?)
    func setNavigationBarTitleLabelTextColor(_ color: UIColor?)
}

class BaseNavigationBarViewController<View: BaseView>: UIViewController, BaseNavigationBarViewControllerProtocol {

    // MARK: - UI
    
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
    
    let contentView: BaseView = View()
    
    // MARK: - properties
    
    let backgroundColor: UIColor = .backgroundColor
    let tintColor: UIColor = .label
    let titleFont: UIFont = .systemFont(ofSize: 20, weight: .semibold)
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupNavigationBar()
        setupProperties()
    }
    
    // MARK: - BaseNavigationBarViewControllerProtocol
    
    func setupNavigationBar() {}
    
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
            contentView.snp.remakeConstraints {
                $0.top.equalTo(statusBar.snp.bottom)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
            }
        } else {
            contentView.snp.remakeConstraints {
                $0.top.equalTo(statusBar.snp.bottom).offset(60)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    func setNavigationBarBackButtonHidden(_ hidden: Bool) {
        navigationBar.backButton.isHidden = hidden
        
        if hidden {
            navigationBar.titleLabel.snp.remakeConstraints {
                $0.left.equalToSuperview().inset(30)
                $0.centerY.equalToSuperview()
            }
        } else {
            navigationBar.titleLabel.snp.remakeConstraints {
                $0.center.equalToSuperview()
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
    
    // MARK: - functions
    
    private func configureUI() {
        view.backgroundColor = .backgroundColor
        view.addSubview(statusBar)
        view.addSubview(navigationBar)
        navigationBar.addSubview(navigationBar.backButton)
        navigationBar.addSubview(navigationBar.titleLabel)
        navigationBar.addSubview(navigationBar.addButton)
        navigationBar.addSubview(navigationBar.moreButton)
        view.addSubview(contentView)
        
        statusBar.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(statusBar.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        navigationBar.backButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        navigationBar.titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        navigationBar.moreButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        navigationBar.addButton.snp.makeConstraints {
            $0.right.equalTo(navigationBar.moreButton.snp.left).offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(statusBar.snp.bottom).offset(60)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
    
    private func setupProperties() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setNavigationBarTintColor(tintColor)
        setNavigationBarTitleLabelFont(titleFont)
        setNavigationBarBackButtonHidden(true)
        setNavigationBarMenuButtonHidden(true)
        
        navigationBar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
