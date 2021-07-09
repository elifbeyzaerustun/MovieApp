//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Elif Erustun on 9.07.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Variables
    lazy var loadingContainerView: UIView = {
        let container: UIView = UIView()
        container.frame = UIScreen.main.bounds
        container.backgroundColor = .clear
        
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = container.center
        activityView.color = UIColor.systemBlue
        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
        
        return container
    }()
    
    private var observer: NSObjectProtocol!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotificationObservers()
    }
    
    // MARK: Configuration
    func startLoading() {
        self.view.isUserInteractionEnabled = false
        self.loadingContainerView.isHidden = false
    }
    
    func stopLoading() {
        self.view.isUserInteractionEnabled = true
        self.loadingContainerView.isHidden = true
    }
    
    private func setNotificationObservers() {
        observer = NotificationCenter.default.addObserver(forName: .isLoadingStarted, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }

            if isLoadingStarted {
                self.startLoading()
            } else {
                self.stopLoading()
            }
        }
    }
}
