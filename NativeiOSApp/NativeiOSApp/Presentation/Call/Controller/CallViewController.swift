//
//  CallViewController.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import UIKit
import ARKit

final class CallViewController: UIViewController {

    @IBAction private func tappedAnimationButton(_ sender: UIButton) {
        presenter?.sendData()
    }

    @IBOutlet private weak var avatarView: UIView!
    @IBOutlet private weak var partnerView: UIView!

    private var presenter: CallPresenterInput?
    private let unityView = Unity.shared.view

    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = CallPresenter(view: self, useCase: CallUseCase())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        presenter?.viewWillDisappear()
    }

}

// MARK: - CallPresenterOutPut

extension CallViewController: CallPresenterOutPut {

    func showLocalView() {
        avatarView.addSubview(unityView)
        unityView.frame = avatarView.bounds
        avatarView.sendSubviewToBack(unityView)
    }

    func sendRemoteView(uid: UInt) {
        AgoraRtcManager.shared.sendUnityViewAsAgoraView(frame: avatarView, uid: uid)
    }

    func displayRemoteVideo(uid: UInt) {
        AgoraRtcManager.shared.displayRemoteVideo(remoteView: partnerView, uid: uid) {
            print("相手の画像表示に成功")
        }
    }

}
