//
//  CallUseCase.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/12.
//  Copyright © 2024 unity. All rights reserved.
//

import AgoraRtmKit
import AgoraRtcKit
import Foundation

// 通話のビジネスロジックを管理するUseCase

protocol CallDelegate: AnyObject {
    func shouldSendRemoteVideo(_ useCase: CallUseCase, uid: UInt)
    func shouldDisplayRemoteVideo(_ useCase: CallUseCase, uid: UInt)
}

// MARK: - Input

protocol CallUseCaseInput: AnyObject {

    var callDelegate: CallDelegate? { get set }

    func initializeAgoraEngine()
    func setExternalVideoSource()
    func joinChannel(completion: @escaping () -> Void)
    func leaveChannel(completion: @escaping () -> Void)

}

// MARK: - Output

protocol CallUseCaseOutput: AnyObject {

}

// MARK: - Class

final class CallUseCase: NSObject {

    weak var callDelegate: CallDelegate?

}

// MARK: - CallUseCaseInput

extension CallUseCase: CallUseCaseInput {

    func initializeAgoraEngine() {
        AgoraRtcManager.shared.setup(appId: Constants.appId, delegate: self)
    }

    func setExternalVideoSource() {
        AgoraRtcManager.shared.setExternalVideoSource()
    }

    func joinChannel(completion: @escaping () -> Void) {
        AgoraRtcManager.shared.joinChannel(token: "", channelId: Constants.channelId) {
            AgoraRtcManager.shared.setClientRole(role: .broadcaster)
            completion()
        }
    }

    func leaveChannel(completion: @escaping () -> Void) {
        AgoraRtcManager.shared.leaveChannel {
            completion()
        }
    }

}

// MARK: - AgoraRtcEngineDelegate

extension CallUseCase: AgoraRtcEngineDelegate {

    // Rtcに参加
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        self.callDelegate?.shouldSendRemoteVideo(self, uid: uid)
    }
    
    /// はじめて音声がデコードされたときに呼ばれる 相手がミュートしていると呼ばれない
    func rtcEngine(_ engine: AgoraRtcEngineKit,
                   firstRemoteAudioFrameDecodedOfUid uid: UInt, elapsed: Int) {
        callDelegate?.shouldDisplayRemoteVideo(self, uid: uid)
    }

}

