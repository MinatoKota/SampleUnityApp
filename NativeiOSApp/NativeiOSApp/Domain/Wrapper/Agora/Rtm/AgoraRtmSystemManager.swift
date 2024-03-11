//
//  AgoraRtmSystemManager.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/11.
//  Copyright © 2024 unity. All rights reserved.
//

import AgoraRtmKit

// RTMシステムのログイン、ログアウトとPeerメッセージの送信を管理するクラス
final class AgoraRtmSystemManager {

    /// メッセージを送る際に準拠しているべき型
    /// RtmMessageは送受信でデータの型を合わせるために使用する
    typealias RtmMessageSendable = Encodable & RtmMessage

    // MARK: - Properties

    private(set) var kit: AgoraRtmKit?
    static let shared = AgoraRtmSystemManager()

    // MARK: - LifeCycles

    private init() {}

    // MARK: - Methods

    /// RtmKitを生成。アプリ起動時にAppDelegateで呼ぶ。
    /// - Parameter appId: アプリのId(Agoraで発行されるもの)
    func setup(appId: String) {
        kit = AgoraRtmKit(appId: appId, delegate: nil)
    }

    /// Delegateの更新。メッセージを受け取るクラスを指定するときに呼ぶ。
    /// - Parameter delegate: PeerToPeerメッセージを受け取りたいクラスを指定する。
    func updateDelegateTo(_ delegate: AgoraRtmDelegate) {
        kit?.agoraRtmDelegate = delegate
    }

    /// 特定の相手に対して、メッセージを送るときに呼ぶ。
    /// 送信先の相手もRtmシステムにログインしていないと、メッセージは送れない。
    /// - Parameters:
    ///   - message: 相手に送りたいメッセージ
    ///   - partnerId: メッセージを送信したい相手のID(Jamboサーバーで発行されるもの)
    ///   - completion: メッセージ送信に成功したときはsuccessが返る。
    ///                 ErrorCode200番はEncodeされたメッセージをString型にできなかった場合、201番は送信メッセージがEncodeできなかったときに返る。
    ///                 それ以外のErrorCodeはAgoraRtmSendPeerMessageErrorCodeを参照
    func sendPeerMessage<T: RtmMessageSendable>(message: T, to partnerId: String,
                                                completion: @escaping (ResultWithErrorCode<Void, Int>) -> Void) {
        do {
            let encodedMessage = try JSONEncoder().encode(message)
            let messageString = String(data: encodedMessage, encoding: .utf8)
            guard let messageString = messageString else {
                print("🚀RTM P2Pメッセージ送信に失敗 errorCode: 200")
                completion(.failure(200))
                return
            }
            let sendingMessage = AgoraRtmMessage(text: messageString)
            kit?.send(sendingMessage, toPeer: partnerId, completion: { code in
                print("🚀RTM P2Pエラーコード errorCode: ", code.rawValue)
                switch code {
                case .ok:
                    print("🚀RTM P2Pのメッセージ送信に成功")
                    completion(.success(()))
                default:
                    print("🚀RTM P2Pメッセージ送信に失敗 errorCode: ", code.rawValue)
                    completion(.failure(code.rawValue))
                }
            })
        } catch {
            print("🚀RTM P2Pメッセージ送信に失敗 errorCode: 201")
            completion(.failure(201))
        }
    }

    /// Rtmシステムにログインするときに呼ぶ。
    /// Rtmシステムにログインしていないと、チャンネルへの入室、メッセージの送信などRtm関連の頃が一切できないので要注意。
    /// - Parameters:
    ///   - token: RtmAuthToken(Jamboサーバーで発行される) →API、"get_rtm_login_auth"のレスポンスで返ってくる。
    ///   - userId: 自身のユーザーID(Jamboサーバーで発行される)
    ///   - completion: ログイン成功時、またはすでにログインしている場合はsuccessが返る。それ以外の場合はErrorCodeとともにfailureが返る。
    ///                 ErrorCodeはAgoraRtmLoginErrorCodeを参照。
    func loginRtmSystem(token: String, userId: String, completion: @escaping (ResultWithErrorCode<Void, Int>) -> Void) {
        kit?.login(byToken: token, user: userId, completion: { code in
            print("🚀loginRtmSystem errorCode: ", code.rawValue)
            switch code {
            case .ok, .alreadyLogin:
                print("🚀RTMSystemにログイン完了")
                completion(.success(()))
            default:
                print("🚀RTMSystemにログイン失敗 エラーコード: ", code.rawValue)
                completion(.failure(code.rawValue))
            }
        })
    }

    /// Rtmシステムからログアウトする
    /// - Parameter completion: ログアウトに成功したらsuccessが返る。それ以外の場合はErrorCodeとともにfailureが返る。
    /// ErrorCodeはAgoraRtmLogoutErrorCodeを参照。
    func logoutRtmSystem(completion: @escaping (ResultWithErrorCode<Void, Int>) -> Void) {
        kit?.logout(completion: { code in
            switch code {
            case .ok:
                print("🚀RtmSystemログアウト成功")
                completion(.success(()))
            default:
                completion(.failure(code.rawValue))
            }
        })
    }
}
