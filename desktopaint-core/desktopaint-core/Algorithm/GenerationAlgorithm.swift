//
//  GenerationAlgorithm.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/28/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation
import RxSwift

protocol DataGenerationType {

    var screenSize: CGSize { get }
    var scaleHeight: CGFloat { get }
    var originalImage: NSImage { get }
}

protocol GenerationAlgorithm {

    func process(data: DataGenerationType) -> NSImage
}
