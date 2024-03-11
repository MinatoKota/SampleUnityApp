//
//  CallViewController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit

final class CallViewController: UIViewController {

    @IBAction private func tappedAnimationButton(_ sender: UIButton) {
        presenter?.sendData()
    }

    @IBOutlet private weak var avatarView: UIView!

    private var presenter: CallPresenterInput?
    private let unityView = Unity.shared.view

    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = CallPresenter(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        avatarView.addSubview(unityView)
        unityView.frame = avatarView.bounds
        avatarView.sendSubviewToBack(unityView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

}

// MARK: - CallPresenterOutPut

extension CallViewController: CallPresenterOutPut {


}
