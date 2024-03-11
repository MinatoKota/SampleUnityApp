//
//  RtmMessage.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/11.
//  Copyright © 2024 unity. All rights reserved.
//

import Foundation

protocol RtmMessage {
    var messageType: RtmMessageType { get }
}

// アプリ内で使うRtmのメッセージタイプを追加する。
// 受け取り時は、このメッセージタイプで受け取ったあとの処理をする。
enum RtmMessageType: String {
    case chat
    case leave_live
    case videoCallReply
    case videoCallFromStandby
    case liveCallReply
    case liveFromStandby
    case voiceCallReply
    case increasePoint
    case peepIncreasePoint
    case forceEndLive
    case peep_chat
    case unknown
}
