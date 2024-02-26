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
        // addSubView
        view.addSubview(unityView)
        // 追加したsubViewのサイズをViewControllerのViewのサイズに合わせる
        unityView.frame = view.frame
        // 追加したsubViewを背面へ（addSubViewは最前面に追加するため、ViewControllerのViewの後ろに設定する必要がある）
        view.sendSubviewToBack(unityView)
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
