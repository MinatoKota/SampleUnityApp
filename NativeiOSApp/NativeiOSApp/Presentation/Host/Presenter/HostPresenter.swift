//
//  HostPresenter.swift
//  NativeiOSApp
//
//  Created by minato on 2024/02/26.
//  Copyright © 2024 unity. All rights reserved.
//

import Foundation

protocol HostPresenterInput {
    func sendData(data: [String?])
}

final class HostPresenter: HostPresenterInput {
    func sendData(data: [String?]) {
        // 引数はStringなので、それに合わせる
        let dataText =
            """
            {\"data0\": \(data[0]!), \"data1\": \(data[1]!), \"data2\": \(data[2]!),
            \"data3\": \(data[3]!), \"data4\": \(data[4]!), \"data5\": \(data[5]!)}
            """
        // UnityFrameworkdのメソッドを呼び出す
        Unity.shared
            .sendMessageToUnity(objectName: "SampleData", functionName: "SetData", argument: dataText)
    }
}
