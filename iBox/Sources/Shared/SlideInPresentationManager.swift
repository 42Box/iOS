//
//  SlideInPresentationManager.swift
//  iBox
//
//  Created by Chan on 4/23/24.
//

import UIKit

// Presentation Manager 수정
class SlideInPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(isPresentation: false)
    }
}

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

class TransparentTouchView: UIView {
    var passThroughArea: CGRect?

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 터치 포인트가 passThroughArea 안에 있으면 false를 반환하여 이벤트를 무시
        if let passThroughArea = passThroughArea, passThroughArea.contains(point) {
            print("passtrou")
            return false
        }
        return true
    }
}

class PassthroughView: UIView {
    var passThroughAreas: [CGRect] = []

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for rect in passThroughAreas {
            if rect.contains(point) {
                return false
            }
        }
        return true
    }
}

class HalfSizePresentationController: UIPresentationController {
    private var dimmingView: PassthroughView!

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        dimmingView = PassthroughView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4) // 조절 가능
        dimmingView.passThroughAreas = [
            CGRect(x: 0, y: containerView.bounds.height / 2, width: containerView.bounds.width, height: containerView.bounds.height / 2) // 하단 절반
        ]

        containerView.addSubview(dimmingView)
        containerView.sendSubviewToBack(dimmingView)
        
        super.presentationTransitionWillBegin()
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }
}
