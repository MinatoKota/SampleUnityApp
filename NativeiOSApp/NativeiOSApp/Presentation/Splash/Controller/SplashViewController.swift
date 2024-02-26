//
//  SplashViewController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/23.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        transitionHostViewVC()
    }

}

// MARK: - Private

private extension SplashViewController {

    func transitionHostViewVC() {
        DispatchQueue.main.async {
            AppDelegate.shared.rootVC.transitionToMainTab()
        }
    }

}
