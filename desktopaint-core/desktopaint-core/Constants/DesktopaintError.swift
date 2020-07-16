//
//  DesktopaintError.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/21/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation

enum DesktopaintError: Error {

    case serializeError(Any)
    case saveImageError(String)
    case invalidFileURL(URL)
}

extension DesktopaintError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .serializeError(let obj):
            return "Can't serialize \(obj.self)"
        case .saveImageError(let path):
            return "Can't Save image \(path)"
        case .invalidFileURL(let path):
            return "Can't read image file from \(path)"
        }
    }
}
