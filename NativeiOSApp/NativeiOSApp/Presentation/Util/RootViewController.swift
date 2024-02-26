//
//  RootViewController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/23.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {

    // MARK: - Properties

    private var currentVC: UIViewController

    // MARK: - LifeCycle

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // ここで起動時に表示する画面を変更
    init() {
        let vc = SplashViewController()
        currentVC = vc
        super.init(nibName: nil, bundle: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        addCurrentVCAsChild()
    }

    // MARK: - Methods

    func transitionToHostVC() {
        let vc = HostViewController()
        transition(to: vc)
    }

    func transitionToMainTab() {
        let vc = MainTabBarController()
        transition(to: vc)
    }

}

// MARK: - Private Methods

private extension RootViewController {

    // currentVCをRootVCの子VCとして追加
    func addCurrentVCAsChild() {
        addChild(currentVC)
        currentVC.view.frame = view.bounds
        view.addSubview(currentVC.view)
        currentVC.didMove(toParent: self)
    }

    // RootVCの子VCを入れ替えることでルートの画面を切り替える
    func transition(to vc: UIViewController) {
        addChild(vc)
        vc.view.frame = view.bounds
        vc.view.backgroundColor = .white
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        currentVC.willMove(toParent: nil)
        currentVC.view.removeFromSuperview()
        currentVC.removeFromParent()
        currentVC = vc
    }
}

