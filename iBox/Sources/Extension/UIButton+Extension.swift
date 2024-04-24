//
//  UIButton+Extension.swift
//  iBox
//
//  Created by Chan on 4/25/24.
//

import UIKit
import ObjectiveC

private var touchDownColorKey: UInt8 = 0
private var touchUpColorKey: UInt8 = 0

extension UIButton {
    var touchDownColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &touchDownColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &touchDownColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var touchUpColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &touchUpColorKey) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &touchUpColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addAnimationForStateChange(from: UIColor, to: UIColor) {
        self.touchDownColor = from
        self.touchUpColor = to
        addTarget(self, action: #selector(animateOnTouchDown), for: .touchDown)
        addTarget(self, action: #selector(animateOnTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func animateOnTouchDown() {
        if let color = touchDownColor {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = color
            }
        }
    }

    @objc private func animateOnTouchUp() {
        if let color = touchUpColor {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = color
            }
        }
    }
}
