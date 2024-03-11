//
//  AgoraRtcManager.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/11.
//  Copyright © 2024 unity. All rights reserved.
//

import Foundation
import AgoraRtcKit

final class AgoraRtcManager{

    // MARK: - Properties

    private var kit: AgoraRtcEngineKit?
    static let shared = AgoraRtcManager()

    // MARK: - LifeCycles

    private init() {}

    // MARK: - Methods

    /// RtcKitのセットアップ。BeautyOptionも行っている。Rtc関連の処理をするときにまず初めに呼ぶ。
    /// このメソッドが呼ばれていないと、あとの処理が全てできない。
    /// - Parameters:
    ///   - appId: Agoraで発行されるアプリのId
    ///   - delegate: チャンネルの退室などを検知するメソッドを使うクラスを指定する。
    func setup(appId: String, delegate: AgoraRtcEngineDelegate) {
        kit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: delegate)
        kit?.enableVideo()
        addBeautyOptions()
        print("🚀RTCのセットアップ完了")
    }

    /// AgoraRtcEngineDelegateを更新したいときに呼ぶ。
    /// デリゲートにセットしたクラスで、相手がオフラインになったこと、RemoteViewのUIDなどを受け取れる。
    /// - Parameter delegate: 処理を受け取りたいクラスを指定する。
    func updateDelegate(delegate: AgoraRtcEngineDelegate) {
        kit?.delegate = delegate
    }

    /// Rtcチャンネルに入室するときに呼ぶ。
    /// - Parameters:
    ///   - token: Rtcチャンネルに入るためのトークン。(Jamboサーバーで発行される)
    ///   - channelId: 固有のものなら何でも良い。(Jamboサーバーで発行される)
    ///   - info:チャンネルについての追加情報を追加できる。なくても問題ない。
    ///   - completion: チャンネルに入室したら呼ばれる。
    func joinChannel(token: String, channelId: String, info: String? = nil, completion: @escaping () -> Void) {
//        let userId = LoginUser.shared.getUserId()
//        let uid = AgoraUIDGenerator.generate(from: userId)
//        kit?.joinChannel(byToken: token, channelId: channelId, info: info, uid: uid, joinSuccess: { result1, result2, result3 in
//            completion()
//        })
    }

    /// チャンネルから退室するときに呼ぶ。
    /// - Parameter completion: チャンネルから退室したら呼ばれる。
    func leaveChannel(completion: @escaping () -> Void) {
        kit?.leaveChannel({ _ in
            print("🚀RTCチャンネルから退出しました")
            completion()
        })
    }

    /// チャンネルでの役割を指定するときに呼ぶ。
    /// - Parameter role: .audienceと.broadcasterのどちらかを指定する。
    func setClientRole(role: AgoraClientRole) {
        kit?.setClientRole(role)
        print("🚀クライアント設定完了")
    }

    /// kitを消去する。Rtcから抜けるときに使うと良い。
    /// 再度Rtcを使うときはsetupから行うこと。
    func destroyKit() {
        print("🚀RtcKit破棄成功")
        AgoraRtcEngineKit.destroy()
    }

    /// 相手の映像を映すときに呼ぶ。
    /// - Parameters:
    ///   - remoteView: 相手の映像を映したいViewを指定する。
    ///   - uid: 相手が映像を写したときに、AgoraRtcEngineDelegateのfirstRemoteAudioFrameDecodedOfUidから取得できる。
    func displayRemoteVideo(remoteView: UIView, uid: UInt, completion: @escaping () -> Void) {
        guard let kit = kit else { return }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .hidden
        kit.setupRemoteVideo(videoCanvas)
        completion()
    }

    /// 自分の映像を映すときに呼ぶ。
    /// - Parameter localView: 自分の映像を映したいViewを指定する。
    func displayLocalVideo(localView: UIView) {
        guard let kit = kit else { return }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localView
        videoCanvas.renderMode = .hidden
        kit.setupLocalVideo(videoCanvas)
        kit.startPreview()
    }

    /// 自分の音をミュートにする。
    func muteLocalAudio(_ mute: Bool) {
        kit?.muteLocalAudioStream(mute)
    }

    /// 自分の映像をミュートにする
    func muteLocalVideo(_ mute: Bool) {
        kit?.muteLocalVideoStream(mute)
    }

    /// 音声通話時にスピーカーから音を出すか選択
    func changeSpeaker(_ isSpeaker: Bool) {
        kit?.setEnableSpeakerphone(isSpeaker)
    }

    /// 特定のユーザーの音をミュートにするときに呼ぶ。
    func muteRemoteAudio(uid: UInt) {
        kit?.muteRemoteAudioStream(uid, mute: true)
    }

    /// すべてのリモートユーザーの音をミュートにするときに呼ぶ。
    func muteAllRemoteAudio(isMute: Bool) {
        kit?.muteAllRemoteAudioStreams(isMute)
    }

    /// 特定のユーザーの音のミュートを解除するときに呼ぶ。
    func unMuteRemoteAudio(uid: UInt) {
        kit?.muteRemoteAudioStream(uid, mute: false)
    }

    /// 自分のカメラの内外を入れ替えるときに呼ぶ。
    func switchCamera() {
        kit?.switchCamera()
    }
}

// MARK: - Private Methods

private extension AgoraRtcManager {

    /// 美白フィルター
    func addBeautyOptions() {
        let beautyOptions = AgoraBeautyOptions()
        beautyOptions.lighteningContrastLevel = .normal
        beautyOptions.rednessLevel = 0.1
        beautyOptions.smoothnessLevel = 0.7
        beautyOptions.lighteningLevel = 0.7
        kit?.setBeautyEffectOptions(true, options: beautyOptions)
    }
}
