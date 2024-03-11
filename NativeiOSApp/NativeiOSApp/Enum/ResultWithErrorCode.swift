//
//  ResultWithErrorCode.swift
//  NativeiOSApp
//
//  Created by minato on 2024/03/11.
//  Copyright © 2024 unity. All rights reserved.
//

import Foundation

enum ResultWithErrorCode<Success, Failure> {
    case success(Success)
    case failure(Failure)
}
