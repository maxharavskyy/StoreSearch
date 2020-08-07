//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Макс Гаравський on 12.03.2020.
//  Copyright © 2020 Макс Гаравський. All rights reserved.
//

import UIKit

class DimmingPrensentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    
    var dimmingView = GradientView(frame: CGRect.zero)
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView
            , at: 0)
        
        dimmingView.alpha = 0
        if let cordinator = presentedViewController.transitionCoordinator { cordinator.animate(alongsideTransition: {_ in self.dimmingView.alpha = 1}, completion: nil) }
    }
    override func dismissalTransitionWillBegin() {
        if let cordinator = presentedViewController.transitionCoordinator {
            cordinator.animate(alongsideTransition: {_ in self.dimmingView.alpha = 0}, completion: nil)
        }
    }
    
}
