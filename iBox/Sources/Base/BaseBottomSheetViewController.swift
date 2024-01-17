//
//  BaseBottomSheetViewController.swift
//  iBox
//
//  Created by jiyeon on 1/5/24.
//

import UIKit

import SnapKit

class BaseBottomSheetViewController<View: BaseView>: UIViewController {
    
    // MARK: - properties
    
    var bottomSheetHeight: CGFloat
    
    // MARK: - UI
    
    let dimmedView = UIView().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }
    
    let sheetView = View().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 왼쪽 위, 오른쪽 위 둥글게
    }
    
    // MARK: - initializer
    
    init(bottomSheetHeight: CGFloat) {
        self.bottomSheetHeight = bottomSheetHeight
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheets()
    }
    
    // MARK: - configure UI
    
    private func configureUI() {
        view.addSubview(dimmedView)
        view.addSubview(sheetView)
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sheetView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(bottomSheetHeight)
        }
    }
    
    // MARK: - functions
    
    private func setupGestureRecognizer() {
        // TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        dimmedView.addGestureRecognizer(dimmedTap)
        
        // SwipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheets()
    }
    
    @objc private func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheets()
            default:
                break
            }
        }
    }
    
    private func showBottomSheets() {
        sheetView.snp.remakeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(bottomSheetHeight)
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideBottomSheets() {
        sheetView.snp.remakeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(bottomSheetHeight)
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
