//
//  CallPresenter.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import Foundation

protocol CallPresenterInput: AnyObject {
    func sendData()

}

protocol CallPresenterOutPut: AnyObject {

}

final class CallPresenter: CallPresenterInput {

    private weak var view: CallPresenterOutPut?

    init(view: CallPresenterOutPut) {
        self.view = view
    }

    func sendData() {

        // UnityFrameworkdのメソッドを呼び出す
        Unity.shared
            .sendMessageToUnity(objectName: "miku", functionName: "PlayMotion", argument: "")
    }

}

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
