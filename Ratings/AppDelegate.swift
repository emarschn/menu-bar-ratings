//
//  AppDelegate.swift
//  Ratings
//
//  Created by Eric Marschner on 3/15/18.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        MenuBarController.instance.go()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // 
        
    }
    
}
