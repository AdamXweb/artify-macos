//
//  AppUpdater.swift
//  Desktopaint
//
//  Created by Nghia Tran on 6/12/18.
//  Copyright © 2020 com.topre.Desktopaint.app. All rights reserved.
//

import Foundation
import Sparkle
import desktopaint_core

final class SparkleUpdater: AppUpdatable {

    // MARK: - Variable
    private let updater = SUUpdater.shared()!

    func checkForUpdate() {
        updater.checkForUpdates(nil)
    }
}
