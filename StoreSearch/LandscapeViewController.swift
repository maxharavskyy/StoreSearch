//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Макс Гаравський on 24.03.2020.
//  Copyright © 2020 Макс Гаравський. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    
    
    var search: Search!
    private var firstTime = true
    private var downloads = [URLSessionTask]()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        pageControl.numberOfPages = 0
        
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        scrollView.frame = safeFrame
        pageControl.frame = CGRect(x: safeFrame.origin.x, y: safeFrame.size.height - pageControl.frame.size.height, width: safeFrame.size.width, height: pageControl.frame.size.height)
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        
        if firstTime {
            firstTime = false
            tileButtons(search.searchResults)
        }
        
    }
    
    deinit {
        print("deinit \(self)")
        for task in downloads {
            task.cancel()
        }
    }
    
//MARK:-Actions
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn] , animations: {
            self.scrollView.contentOffset  = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)}, completion: nil)
    }
    

//MARK:- Private Methods
    
    
    
    private func tileButtons(_ searchResults: [SearchResult]) {
        var columnsPerPage = 6
        var rowPerPage = 3
        var itemWidth: CGFloat = 94
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 2
        var marginY: CGFloat = 20
        
        let viewWidth = scrollView.bounds.size.width
        
        switch viewWidth {
        case 568:
            break
        case 667:
             columnsPerPage = 6
             itemWidth = 95
             itemHeight = 98
             marginX = 1
             marginY = 29
        case 736:
            columnsPerPage = 8
            rowPerPage = 4
            itemHeight = 92
            marginX = 0
        case 724:
            columnsPerPage = 8
            rowPerPage = 3
            itemWidth = 90
            itemHeight = 98
            marginX = 2
            marginY = 29
        default:
            break
        }
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth)/2
        let paddingVert = (itemHeight - buttonHeight)/2
        
        
//        add buttons
        var row = 0
        var column = 0
        var x = marginX
        for (index, result) in searchResults.enumerated() {
            // Create button
            let button = UIButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "LandscapeButton"), for: .normal)
            downloadImage(for: result, andPlaceOn: button)
            // Set button frame
            button.frame = CGRect(x: x + paddingHorz, y: marginY + CGFloat(row)*itemHeight + paddingVert, width: buttonWidth, height: buttonHeight)
            // Add button
            scrollView.addSubview(button)
            // Calculate next button position
            row += 1
            if row == rowPerPage {
                row = 0; x += itemWidth; column += 1
                
                if column == columnsPerPage {
                    column = 0; x += marginX * 2
                }
            }
        }
//        scroll view content size
        let buttonPerPage = columnsPerPage * rowPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonPerPage
        scrollView.contentSize = CGSize(width: CGFloat(numPages) * viewWidth, height: scrollView.bounds.size.height)
        
        print("Number of pages: \(numPages)")
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
    }



private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
    if let url = URL(string: searchResult.imageSmall) {
        let task = URLSession.shared.downloadTask(with: url) {
            [weak button] url, responce, error in
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let button = button {
                        button.setImage(image, for: .normal)
                    }
                }
            }
        }
        task.resume()
        downloads.append(task)
    }

 }



}

//MARK:-
extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let page = Int((scrollView.contentOffset.x + width / 2) / width)
        pageControl.currentPage = page
    }
    
}

