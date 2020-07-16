//
//  OpenURLAction.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 6/19/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation

struct OpenURLAction: PushAction {

    var type: PushActionType { return .openURL }

    var title: String { return "Detail" }

    var url: String { return photoURL }

    // MARK: - Variable
    private let photoURL: String

    // MARK: - Init
    init(photoURL: String) {
        self.photoURL = photoURL
    }
}
