//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Макс Гаравський on 12.03.2020.
//  Copyright © 2020 Макс Гаравський. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(displayP3Red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        let  gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        if searchResult != nil {
            updateUI()
        }
        view.backgroundColor = UIColor.clear
    }
    
    enum AnimationStyle {
        case slide
        case fade
    }
    var dismissStyle = AnimationStyle.fade

    
    
    // MARK: - Actions
    @IBAction func close() {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    // MARK: - showing data in popUp
    
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Artist name label")
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        
        let priceText: String
        if searchResult.price == 0 {
            priceText = NSLocalizedString("Free", comment: "Price text")
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        }  else {
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
    }
    
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    
    
    
    
    
}

// MARK: -  perform presentationing controller
extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPrensentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
        
    }
    
    
}
// MARK: - gesture recognizer exstension

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool  {
        return (touch.view === self.view)
    }
}


