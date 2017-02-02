//
//  DragAppController.swift
//  iDragProject
//
//  Created by runforever on 2016/12/8.
//  Copyright © 2016年 defcoding. All rights reserved.
//

import Cocoa

class DragAppController: NSObject, NSWindowDelegate, NSDraggingDestination {

    @IBOutlet weak var dragMenu: NSMenu!
    let dragStatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    override func awakeFromNib() {
        dragStatusItem.title = "iDrag"
        dragStatusItem.menu = dragMenu

        dragStatusItem.button?.window?.registerForDraggedTypes([NSFilenamesPboardType])
        dragStatusItem.button?.window?.delegate = self

    }

    func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.copy
    }

    func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteBoard = sender.draggingPasteboard()
        let filePaths = pasteBoard.propertyList(forType: NSFilenamesPboardType) as! NSArray

        let uploadManager = DragUploadManager()
        uploadManager.uploadFiles(filePaths: filePaths)
        return true
    }

    @IBAction func quitAction(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }

}
