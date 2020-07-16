//
//  NSImage+Extenstion.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/29/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation


var scScale: CGFloat{ 1.0 };

extension NSImage {
    
    var pixelSize: CGSize {
        let imageRep = representations.first!
        return CGSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh)
    }


    var pointSize: CGSize {
        let size = pixelSize
        return CGSize(width: size.width / scScale, height: size.height / scScale)
        
    }
    
}
