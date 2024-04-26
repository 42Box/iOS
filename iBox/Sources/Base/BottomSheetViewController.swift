//
//  BottomSheetViewController.swift
//  iBox
//
//  Created by jiyeon on 1/5/24.
//

import UIKit

import SnapKit

class BottomSheetViewController<View: UIView>: UIViewController {
    
    var bottomSheetHeight: CGFloat
    
    // MARK: - UI Components
    
    let dimmedView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }
    
    let sheetView = View().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 왼쪽 위, 오른쪽 위 둥글게
    }
    
    let indicator = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .darkGray
    }
    
    // MARK: - Initializer
    
    init(bottomSheetHeight: CGFloat) {
        self.bottomSheetHeight = bottomSheetHeight
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperty()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheets()
    }
    
    // MARK: - Setup Methods
    
    private func setupProperty() {
        // TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(dimmedTap)
        
        // SwipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    private func setupHierarchy() {
        view.addSubview(dimmedView)
        view.addSubview(sheetView)
        sheetView.addSubview(indicator)
    }
    
    private func setupLayout() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sheetView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(bottomSheetHeight)
        }
        
        indicator.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(4)
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Action Functions
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheets()
    }
    
    @objc private func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down: hideBottomSheets()
            default: break
            }
        }
    }
    
    // MARK: - Bottom Sheet Action
    
    private func showBottomSheets() {
        sheetView.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(bottomSheetHeight)
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.backgroundColor = .dimmedViewColor
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideBottomSheets() {
        sheetView.snp.remakeConstraints { make in
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(bottomSheetHeight)
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false)
            }
        }
    }
    
}
