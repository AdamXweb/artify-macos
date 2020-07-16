//
//  Environment.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/20/18.
//  Copyright © 2018 com.art.Desktopaint.core. All rights reserved.
//

import Foundation

public struct Environment {

    public enum Kind {
        case sandbox
        case production
    }

    // MARK: - Variable
    let kind: Kind
    var baseURL: String {
        switch kind {
        case .sandbox:
            return "https://api.proxyman.app"

//            return "http://0.0.0.0:7300"
        case .production:
            return "https://api.proxyman.app"
        }
    }
}
