//
//  SettingViewController.swift
//  iDragProject
//
//  Created by runforever on 2017/2/3.
//  Copyright © 2017年 defcoding. All rights reserved.
//

import Cocoa

class SettingViewController: NSViewController {

    @IBOutlet var accessKeyInput: NSTextField!
    @IBOutlet var secretKeyInput: NSTextField!
    @IBOutlet var bucketInput: NSTextField!
    @IBOutlet var domainInput: NSTextField!

    var userDefaults: UserDefaults!
    var settingMeta: [String: NSTextField]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置项与UI的对应配置，方便存取设置数据
        settingMeta = [
            "accessKey": accessKeyInput,
            "secretKey": secretKeyInput,
            "bucket": bucketInput,
            "domain": domainInput,
        ]
        userDefaults = NSUserDefaultsController.shared().defaults

        // 展示已经保存的设置项
        displaySettings()
    }

    func displaySettings() {
        // 根据设置项与UI的对应配置，展示相应的设置到UI中
        for (key, input) in settingMeta {
            if let value = userDefaults.string(forKey: key) {
                input.stringValue = value
            }
        }
    }

    @IBAction func confirmAction(_ sender: NSButton) {
        // 保存UI中的值到配置中
        for (key, input) in settingMeta {
            let setting = input.stringValue
            userDefaults.set(setting, forKey: key)
        }

        userDefaults.synchronize()
        self.view.window?.close()
    }

    @IBAction func cancelAction(_ sender: NSButton) {
        self.view.window?.close()
    }
}
