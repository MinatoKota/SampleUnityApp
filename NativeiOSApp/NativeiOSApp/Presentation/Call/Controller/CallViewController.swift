//
//  CallViewController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit

final class CallViewController: UIViewController {

    private let unityView = Unity.shared.view

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(unityView)
        unityView.frame = view.bounds
        view.sendSubviewToBack(unityView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

}
