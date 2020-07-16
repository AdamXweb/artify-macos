//
//  AboutWindowController.swift
//  Desktopaint
//
//  Created by Nghia Tran on 6/12/18.
//  Copyright © 2018 com.topre.Desktopaint.app. All rights reserved.
//

import Cocoa
import desktopaint_core

final class AboutWindowController: NSViewController {

    @IBOutlet weak var verionLbl: NSTextField!

    class func presentController(_ from: Any) {
        let about = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("AboutWindowController")) as! NSWindowController
        about.showWindow(from)
        NSApp.activate(ignoringOtherApps: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.window?.styleMask = NSWindow.StyleMask(rawValue: self.view.window!.styleMask.rawValue & ~NSWindow.StyleMask.resizable.rawValue)

        let app = AppInfo.current
        verionLbl.stringValue = "Version \(app.appVersion) (\(app.buildNumber))"
    }

    @IBAction func nghiaTranBtnOnTap(_ sender: Any) {
        let url = URL(string: "https://topre.dev")!
        NSWorkspace.shared.open(url)
    }

    @IBAction func DesktopaintMacOSBtnOnTap(_ sender: Any) {
        let url = URL(string: "https://github.com/topre-dev/Desktopaint-macos")!
        NSWorkspace.shared.open(url)
    }

    @IBAction func githubBtnOnTap(_ sender: Any) {
        let url = URL(string: "https://github.com/topre-dev")!
        NSWorkspace.shared.open(url)
    }

}
