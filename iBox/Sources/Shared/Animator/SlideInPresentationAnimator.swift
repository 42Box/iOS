//
//  SlideInPresentationAnimator.swift
//  iBox
//
//  Created by Chan on 4/24/24.
//

import UIKit

class SlideInPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresentation: Bool
    
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = -presentedFrame.height
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        controller.view.frame = initialFrame
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                controller.view.frame = finalFrame
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
    }
}
