//
//  CGSize+String.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 6/1/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation

extension CGSize {

    var toString: String {
        return "\(Int(self.width))_\(Int(self.height))"
    }
}
