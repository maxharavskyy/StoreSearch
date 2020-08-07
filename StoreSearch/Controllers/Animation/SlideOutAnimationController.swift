//
//  SlideOutAnimationController.swift
//  StoreSearch
//
//  Created by Макс Гаравський on 23.03.2020.
//  Copyright © 2020 Макс Гаравський. All rights reserved.
//

import UIKit

class SlideOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView =  transitionContext.view(forKey: UITransitionContextViewKey.from) {
            let containerView = transitionContext.containerView
            let time = transitionDuration(using: transitionContext)
            
            UIView.animate(withDuration: time, animations: {
                fromView.center.y  -= containerView.bounds.size.height
                fromView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { finished in transitionContext.completeTransition(finished)
            })
        }
    }
    
    
}
