//
//  GaussianData.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/29/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation

class GaussianData: DataGenerationType {

    let screenSize: CGSize
    let originalImage: NSImage

    private let ratio: CGFloat = 14.0 / 225.0
    var scaleHeight: CGFloat {
        return screenSize.height - (ratio * screenSize.height * 2.0)
    }

    init(screenSize: CGSize, originalImage: NSImage) {
        self.screenSize = screenSize
        self.originalImage = originalImage
    }
}
