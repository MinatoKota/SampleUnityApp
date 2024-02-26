//
//  AppDelegate.swift
//  NativeiOSApp
//
//  Created by 児玉広樹 on 2020/05/14.
//  Copyright © 2020 unity. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        setRootVC()

        // Unityを呼び出す
        Unity.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
}


// MARK: - private

private extension AppDelegate {

    func setRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
    }
}


