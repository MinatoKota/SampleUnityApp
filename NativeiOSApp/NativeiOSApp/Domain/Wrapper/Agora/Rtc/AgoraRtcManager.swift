//
//  AgoraRtcManager.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/11.
//  Copyright © 2024 unity. All rights reserved.
//

import AgoraRtcKit
import Foundation

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
        kit?.enableAudio()
        print("🚀RTCのセットアップ完了")
    }

    /// ビデオキャプチャー時に必要な設定
    func setExternalVideoSource() {
        kit?.setExternalVideoSource(true, useTexture: true, sourceType: .videoFrame)
        print("🚀CustomVideoSourceセットアップ完了")
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
        kit?.joinChannel(byToken: token, channelId: channelId, info: info, uid: 0, joinSuccess: { result1, result2, result3 in
            completion()
        })
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

    // あくまでもここにビデオデータを渡す必要がある
    func sendUnityViewAsAgoraView(frame: UIView, uid: UInt) {
        var textureBuf: CVPixelBuffer?

        if let pixelBuffer = captureUIViewAsPixelBuffer(view: frame) {
            textureBuf = pixelBuffer
        }

        let videoFrame = AgoraVideoFrame()
        videoFrame.format = 12
        videoFrame.textureBuf = textureBuf
        videoFrame.rotation = 0

        guard let framePushed = kit?.pushExternalVideoFrame(videoFrame, videoTrackId: uid) else { return }
        print("🚀映像データ送りました?\(framePushed)")
    }
}

// MARK: - Private

private extension AgoraRtcManager {

    func captureUIViewAsPixelBuffer(view: UIView) -> CVPixelBuffer? {
        // UIViewのサイズを取得
        let viewSize = view.bounds.size

        // 描画用のコンテキストを作成
        UIGraphicsBeginImageContextWithOptions(viewSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // UIViewの内容を描画
        view.layer.render(in: context)

        // 描画したイメージを取得
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        // UIImageをCGImageに変換
        guard let cgImage = image.cgImage else { return nil }

        // CGImageをCVPixelBufferに変換
        var pixelBuffer: CVPixelBuffer?
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(viewSize.width), Int(viewSize.height), kCVPixelFormatType_32BGRA, options as CFDictionary, &pixelBuffer)
        guard status == kCVReturnSuccess, let finalPixelBuffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(finalPixelBuffer, [])
        let pixelData = CVPixelBufferGetBaseAddress(finalPixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(finalPixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let graphicsContext = CGContext(data: pixelData, width: Int(viewSize.width), height: Int(viewSize.height), bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        graphicsContext?.draw(cgImage, in: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))

        CVPixelBufferUnlockBaseAddress(finalPixelBuffer, [])

        return finalPixelBuffer
    }
}

