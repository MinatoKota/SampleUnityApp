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

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var rootVC: RootViewController {
        return window?.rootViewController as! RootViewController
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Unityの初期化をバックグラウンドで行うため必ず先頭で呼び出す
        Unity.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        setRootVC()
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


