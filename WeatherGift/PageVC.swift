//
//  PageVC.swift
//  WeatherGift
//
//  Created by Bryan Kim on 3/18/18.
//  Copyright © 2018 Bryan Kim. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 44 // CGFloat is graphic numbering system. Width of 44
    var barButtonHeight: CGFloat = 44
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self // this means that I'm gonna listen to special things to happen, and if they happen I'm gonna pass it to the ViewController
        dataSource = self // this ViewController we're creating, the whole class will pay attention to it and will be the source of the data that controls the ViewController
        // when we load the page for the first time, we want to create a page for the 0th element in the array
        
        var newLocation = WeatherLocation()
        newLocation.name = ""
        locationsArray.append(newLocation)
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configurePageControl()
        configureListButton()
    }
    
    //MARK:- UI Configration Methods
    func configurePageControl() { // The dots on the bottom
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        
        pageControl.addTarget(self, action: #selector(pageControlPressed), for: .touchUpInside) // clicking on one of the dots
        
        
        view.addSubview(pageControl) // Always do view.addSubView after configuring the UIButton and creating and setting its action function. Need to add button to current view controller this way
    }
    
    func configureListButton() {
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setImage(UIImage(named: "listButton"), for: .normal)
        listButton.setImage(UIImage(named: "listButton-highlighted"), for:. highlighted)
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        view.addSubview(listButton)
        
    }
    
    //MARK:- Segue
    @objc func segueToListVC() {
        print("Hey you Clicked Me!")
        
        performSegue(withIdentifier: "ToListVC", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {
            return
        }
        locationsArray = currentViewController.locationsArray
        if segue.identifier == "ToListVC" {
            let destination = segue.destination as! ListVC // set destination, in this case, to ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
    }
    
    //MARK:- Create View Controller for UIPageViewController
    func createDetailVC(forPage page: Int) -> DetailVC { // this function is creating another DetailVC.swift
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray // weare creating everything in the PageVC. After we create the detailVC in locationsArray, we want to pass it down to DetailVC.
        detailVC.currentPage = currentPage
        return detailVC
    }
    
}

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1) // swiping from rigt to left, add next page from locationsArray
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1) // now swiping from left to right, getting the page before the current page
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
    
    @objc func pageControlPressed() { // clicking on one of the dots
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {
            return
        }
            currentPage = currentViewController.currentPage
            if pageControl.currentPage < currentPage {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)/* where black dot is */], direction: .reverse, animated: true, completion: nil)
            } else if pageControl.currentPage > currentPage {
                setViewControllers([createDetailVC(forPage: pageControl.currentPage)/* where black dot is */], direction: .forward /* black dot is greater than currentpage*/, animated: true, completion: nil)
            }
        }
    
    
}















