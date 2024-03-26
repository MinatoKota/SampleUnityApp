//
//  CallPresenter.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import Foundation

// MARK: - Input

protocol CallPresenterInput: AnyObject {

    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func sendData()

}

// MARK: - OutPut

protocol CallPresenterOutPut: AnyObject {

    func sendRemoteView()
    func displayRemoteVideo(uid: UInt)
    func showLocalView()

}

// MARK: - Class

final class CallPresenter: NSObject, CallPresenterInput {

    private weak var view: CallPresenterOutPut?
    private let useCase: CallUseCaseInput

    init(view: CallPresenterOutPut, useCase: CallUseCase) {
        self.view = view
        self.useCase = useCase
    }

    func viewDidLoad() {
        useCase.callDelegate = self
        useCase.initializeAgoraEngine()
        useCase.setExternalVideoSource()
        useCase.joinChannel() {
            self.view?.showLocalView()
        }
    }

    func viewWillAppear() {
    }


    func viewWillDisappear() {
        useCase.leaveChannel(){
            AgoraRtcManager.shared.destroyKit()
        }
    }


    func sendData() {
        // UnityFrameworkdのメソッドを呼び出す
        Unity.shared
            .sendMessageToUnity(objectName: "miku", functionName: "PlayMotion", argument: "")
    }
   
}

// MARK: - CallDelegate

extension CallPresenter: CallDelegate {

    func shouldSendRemoteVideo(_ useCase: CallUseCase) {
        view?.sendRemoteView()
    }
    
    func shouldDisplayRemoteVideo(_ useCase: CallUseCase, uid: UInt) {
        view?.displayRemoteVideo(uid: uid)
    }
}

// MARK: - NativePlugin

public class NativePlugin {

    public static func showMessage(_ message: String) {
        print(message)
    }
}

// UnityとSwiftを繋げるための関数
@_cdecl("showMessage")
public func showMessage(message: UnsafePointer<CChar>)
{
    NativePlugin.showMessage(String(cString: message))
}
