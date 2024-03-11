//
//  AgoraRtmChannelManager.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/11.
//  Copyright © 2024 unity. All rights reserved.
//

import AgoraRtmKit


final class AgoraRtmChannelManager {

    typealias RtmMessageSendable = Encodable & RtmMessage

    // MARK: - Properties

    private var channel: AgoraRtmChannel?
    static let shared = AgoraRtmChannelManager()

    // MARK: - LifeCycles

    private init() {}

    // MARK: - Methods

    /// Rtmチャンネルを作成する。新規でRtmチャンネルを作るとき、または、別のRtmチャンネルを作り直すときに呼ぶ。
    /// AgoraRtmSystemManagerのsetupが呼ばれていないとチャンネルは作れない
    /// - Parameters:
    ///   - channelId: RtmのチャンネルId(Jamboサーバーで発行されるもの)
    ///   - delegate: Rtmチャンネルメッセージ、メンバーの入退室などを受け取りたいクラスを指定する。
    func createChannel(channelId: String, delegate: AgoraRtmChannelDelegate) {
        print("🚀RTMチャンネル作成")
        channel = AgoraRtmSystemManager.shared.kit?.createChannel(withId: channelId, delegate: delegate)
    }

    /// すでにチャンネルが作られていて、Rtmチャンネルメッセージやメンバーの入退室などを受け取るクラスのみを変えたいときに呼ぶ。
    /// - Parameter delegate: Rtmチャンネルメッセージ、メンバーの入退室などを受け取りたいクラスを指定する。
    func updateDelegate(_ delegate: AgoraRtmChannelDelegate) {
        channel?.channelDelegate = delegate
    }

    /// 現在入室しているRtmチャンネル全体にメッセージを送るときに呼ぶ。
    /// チャンネルに入室していないと、メッセージは送れない。
    /// - Parameters:
    ///   - message: チャンネルに送りたいメッセージ
    ///   - completion: メッセージ送信に成功したときはsuccessが返る。
    ///                 ErrorCode200番はEncodeされたメッセージをString型にできなかった場合、201番は送信メッセージがEncodeできなかったときに返る。
    ///                 それ以外のErrorCodeはAgoraRtmSendChannelMessageErrorCodeを参照
    func sendChannel<T: RtmMessageSendable>(message: T,
                                                   completion: @escaping (ResultWithErrorCode<Void, Int>) -> Void) {
        do {
            let encodedMessage = try JSONEncoder().encode(message)
            let messageString = String(data: encodedMessage, encoding: .utf8)
            guard let messageString = messageString else {
                completion(.failure(200))
                return
            }
            let sendingMessage = AgoraRtmMessage(text: messageString)
            channel?.send(sendingMessage, completion: { code in
                switch code {
                case .errorOk:
                    completion(.success(()))
                default:
                    completion(.failure(code.rawValue))
                }
            })
        } catch {
            completion(.failure(201))
        }
    }

    /// 現在入室しているRtmチャンネル全体にメッセージを送るときに呼ぶ。
    /// チャンネルに入室していないと、メッセージは送れない。
    /// - Parameters:
    ///   - message: チャンネルに送りたいメッセージ
    ///   - completion: メッセージ送信に成功したときはsuccessが返る。
    ///                 ErrorCode200番はEncodeされたメッセージをString型にできなかった場合、201番は送信メッセージがEncodeできなかったときに返る。
    ///                 それ以外のErrorCodeはAgoraRtmSendChannelMessageErrorCodeを参照
    func sendChannelMessage<T: RtmMessageSendable>(message: T,
                                                   completion: @escaping (ResultWithErrorCode<Void, Int>) -> Void) {
        do {
            let encodedMessage = try JSONEncoder().encode(message)
            let messageString = String(data: encodedMessage, encoding: .utf8)
            guard let messageString = messageString else {
                completion(.failure(200))
                return
            }
            let sendingMessage = AgoraRtmMessage(text: messageString)
            channel?.send(sendingMessage, completion: { code in
                switch code {
                case .errorOk:
                    completion(.success(()))
                default:
                    completion(.failure(code.rawValue))
                }
            })
        } catch {
            completion(.failure(201))
        }
    }

    /// createChannelで作成したチャンネルに入室するときに呼ぶ。
    /// - Parameter completion: 入室に成功、またはすでに入室済みの場合はsuccessが返る。
    ///                         それ以外のときはfailureがErrorCodeとともに返る。ErrorCodeはAgoraRtmJoinChannelErrorCode参照。
    func joinChannel(completion: @escaping (ResultWithErrorCode<Void, Int>) -> Void) {
        channel?.join(completion: { code in
            switch code {
            case .channelErrorOk, .channelErrorAlreadyJoined:
                print("🚀RTMチャンネルに入室完了")
                completion(.success(()))
            default:
                print("🚀RTMチャンネルに入室失敗\(code)")
                completion(.failure(code.rawValue))
            }
        })
    }

    /// createChannelで作成したチャンネルに退室するときに呼ぶ。
    /// - Parameter completion: 退室に成功、部屋にいない場合はsuccessが返る。
    ///                         それ以外のときはfailureがErrorCodeとともに返る。ErrorCodeは AgoraRtmLeaveChannelErrorCodeを参照。
    func leaveChannel(completion: @escaping (ResultWithErrorCode<Void, Int>) -> Void) {
        channel?.leave(completion: { code in
            switch code {
            case .ok, .notInChannel:
                completion(.success(()))
            default:
                completion(.failure(code.rawValue))
            }
        })
    }

    /// チャンネルの全メンバー情報を取得し、カウント数を返す
    func fetchChannelMemberCount(completion: @escaping (ResultWithErrorCode<Int, Int>) -> Void) {
        guard let channel = channel else { return }
        channel.getMembersWithCompletion({ (rtmMember, code) in
            guard let rtmMember = rtmMember else { return }
            switch code {
            case .ok: completion(.success(rtmMember.count))
            default: completion(.failure(code.rawValue))
            }
        })
    }
}
