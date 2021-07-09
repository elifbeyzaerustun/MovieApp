//
//  NotificationCenterExtensions.swift
//  MovieApp
//
//  Created by Elif Erustun on 9.07.2021.
//

import Foundation

extension Notification.Name {
    static let isLoadingStarted = NSNotification.Name(Bundle.main.bundleIdentifier ?? "" + ".isLoadingStarted")
}

var isLoadingStarted: Bool = false {
    didSet {
        NotificationCenter.default.post(name: .isLoadingStarted, object: nil)
    }
}

func showLoadingIndicator() {
    isLoadingStarted = true
}

func hideLoadingIndicator() {
    isLoadingStarted = false
}
