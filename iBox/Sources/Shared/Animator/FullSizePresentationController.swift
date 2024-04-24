//
//  FullSizePresentationController.swift
//  iBox
//
//  Created by Chan on 4/24/24.
//

import UIKit

class FullSizePresentationController: UIPresentationController {
    private var dimmingView: UIView!
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        dimmingView.frame = containerView?.bounds ?? CGRect.zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        containerView.addSubview(dimmingView)
        containerView.sendSubviewToBack(dimmingView)
        
        super.presentationTransitionWillBegin()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
    }
}
