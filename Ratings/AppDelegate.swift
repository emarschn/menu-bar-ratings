//
//  AppDelegate.swift
//  Ratings
//
//  Created by Eric Marschner on 3/15/18.
//

import Cocoa
import ScriptingBridge


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    fileprivate static let iTunesBundle = "com.apple.iTunes"

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        
        setupMenu()
    
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setupMenu() {
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "-", action: #selector(AppDelegate.noRating(_:)), keyEquivalent: "0"))
        menu.addItem(NSMenuItem(title: "★", action: #selector(AppDelegate.oneStarRating(_:)), keyEquivalent: "1"))
        menu.addItem(NSMenuItem(title: "★ ★", action: #selector(AppDelegate.twoStarRating(_:)), keyEquivalent: "2"))
        menu.addItem(NSMenuItem(title: "★ ★ ★", action: #selector(AppDelegate.threeStarRating(_:)), keyEquivalent: "3"))
        menu.addItem(NSMenuItem(title: "★ ★ ★ ★", action: #selector(AppDelegate.fourStarRating(_:)), keyEquivalent: "4"))
        menu.addItem(NSMenuItem(title: "★ ★ ★ ★ ★", action: #selector(AppDelegate.fiveStarRating(_:)), keyEquivalent: "5"))

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
    }
}

// MARK: Actions

extension AppDelegate {
    
    @objc func noRating(_ sender: Any) {
        setRating(0)
    }
    @objc func oneStarRating(_ sender: Any) {
        setRating(20)
    }
    
    @objc func twoStarRating(_ sender: Any) {
        setRating(40)
    }
    
    @objc func threeStarRating(_ sender: Any) {
        setRating(60)
    }
    
    @objc func fourStarRating(_ sender: Any) {
        setRating(80)
    }
    
    @objc func fiveStarRating(_ sender: Any) {
        setRating(100)
    }
}

extension AppDelegate {
    
    func isRunning(bundleId: String) -> Bool {
        let apps = NSWorkspace.shared.runningApplications
        for app in apps {
            if app.bundleIdentifier == bundleId {
                return true
            }
        }
        return false
    }
    
    func setRating(_ rating: Int) {
        if isRunning(bundleId: AppDelegate.iTunesBundle) {
            let itunes: iTunesApplication! = SBApplication(bundleIdentifier: AppDelegate.iTunesBundle)
            let currentTrack = itunes.currentTrack
            currentTrack!.setRating!(rating)
        }
    }
    
}

