//
//  WallpaperPayload.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 6/1/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation

struct WallpaperPayload {

    let photo: Photo
    let originalImage: NSImage
    let screenSize: NSSize
    let effect: Effect
}

struct WallpaperResponse {
    let photo: Photo
    let screenSize: NSSize
    let wallpaperImage: NSImage
}
