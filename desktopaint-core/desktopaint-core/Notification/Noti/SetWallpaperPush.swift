//
//  SetWallpaperPush.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 6/19/18.
//  Copyright © 2018 com.art.Desktopaint.core. All rights reserved.
//

import Foundation

struct SetWallpaperPush: PushContent {

    struct Constants {
        static let DismissInterval: TimeInterval = 12.0
    }

    // Action
    var type: PushContentType { return .applyWallpaperSuccess }

    // Content
    var title: String { return _title }
    var message: String { return _message }
    var hideInterval: TimeInterval? { return Constants.DismissInterval }

    // Sub action
    var actions: [PushAction] {
        return [CloseAtion(), OpenURLAction(photoURL: url)]
    }

    // MARK: - Variable
    fileprivate let _title: String
    fileprivate let _message: String
    fileprivate let url: String

    // MARK: - Init
    init(photo: Photo) {
        _title = photo.name
        _message = "\(photo.author.name) | \(photo.style)"
        url = photo.originalSource
    }
}
