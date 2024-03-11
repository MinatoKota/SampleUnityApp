//
//  MainNavigationController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {

        super.viewDidLoad()

        // 背景色
        navigationBar.barTintColor = .systemGray6

        // テキストスタイル
        navigationBar.prefersLargeTitles = false
        navigationBar.titleTextAttributes = [.font: UIFont(name: "HelveticaNeue-Medium", size: 22)!,
                                             .foregroundColor: UIColor.black]

        // ナビゲーションバーの下の影を無くす
        UINavigationBar.appearance().shadowImage = UIImage()

    }

}
