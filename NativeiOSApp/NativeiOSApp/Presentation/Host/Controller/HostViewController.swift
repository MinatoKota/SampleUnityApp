//
//  HomeViewController.swift
//  NativeiOSApp
//
//  Created by 児玉広樹 on 2020/05/11.
//  Copyright © 2020 unity. All rights reserved.
//

import UIKit

class HostViewController: UIViewController {
    // UnityのViewの読み込み
    private let unityView = Unity.shared.view

    private var presenter: HostPresenterInput!
    func inject(presenter: HostPresenterInput) {
        self.presenter = presenter
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}
