//
//  MenuBarController.swift
//  Ratings
//
//  Created by Eric Marschner on 3/16/18.
//

import Cocoa
import Foundation
import ScriptingBridge

public class MenuBarController {
    
    @nonobjc static var instance : MenuBarController = {
        let instance = MenuBarController()
        return instance
    }()
    
    private init()  {
        setupMenu()
    }
    
    var timer: Timer?
    var lastTrackId: NSInteger = 0
    var lastPlaying = false
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let timerInterval = 5.0
    let iTunesBundle = "com.apple.iTunes"
    
    deinit {
        timer?.invalidate()
    }
    
    func go() {
        setupTimer()
    }
    
    func setupMenuBarButton(_ active: Bool) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.appearsDisabled = false;
            if !active {
                button.appearsDisabled = true;
            }
        }
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func setupMenu() {
        
        let menu = NSMenu()
        menu.autoenablesItems = false
        
        if let rating = getRating() {
            setupMenuBarButton(true)
            let numStars = Star.numStars(for: rating)
            
            let noRating = NSMenuItem(title: "-", action: #selector(noRating(_:)), keyEquivalent: "0")
            noRating.target = self
            menu.addItem(noRating)
            noRating.isEnabled = (numStars != .none)
            
            let oneStar = NSMenuItem(title: "★", action: #selector(oneStarRating(_:)), keyEquivalent: "1")
            oneStar.target = self
            menu.addItem(oneStar)
            oneStar.isEnabled = (numStars != .one)
            
            let twoStar = NSMenuItem(title: "★ ★", action: #selector(twoStarRating(_:)), keyEquivalent: "2")
            twoStar.target = self
            menu.addItem(twoStar)
            twoStar.isEnabled = (numStars != .two)
            
            let threeStar = NSMenuItem(title: "★ ★ ★", action: #selector(threeStarRating(_:)), keyEquivalent: "3")
            threeStar.target = self
            menu.addItem(threeStar)
            threeStar.isEnabled = (numStars != .three)
            
            let fourStar = NSMenuItem(title: "★ ★ ★ ★", action: #selector(fourStarRating(_:)), keyEquivalent: "4")
            fourStar.target = self
            menu.addItem(fourStar)
            fourStar.isEnabled = (numStars != .four)
            
            let fiveStar = NSMenuItem(title: "★ ★ ★ ★ ★", action: #selector(fiveStarRating(_:)), keyEquivalent: "5")
            fiveStar.target = self
            menu.addItem(fiveStar)
            fiveStar.isEnabled = (numStars != .five)
        } else {
            setupMenuBarButton(false)
            
            let notPlayingMenuItem = NSMenuItem(title: "Not Playing", action: nil, keyEquivalent: "")
            notPlayingMenuItem.isEnabled = false
            menu.addItem(notPlayingMenuItem)
        }
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
    }
}

// MARK: Actions

extension MenuBarController {
    
    @objc func update() {
        if let track = getCurrentTrack() {
            if lastTrackId != track.id!() {
                lastTrackId = track.id!()
                setupMenu()
            }
        } else {
            let playing = isPlaying()
            if playing != lastPlaying {
                lastPlaying = playing
                setupMenu()
            }
        }
    }
    
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

extension MenuBarController {
    
    // AppleEvents: received mach msg which wasn't complex type as expected in getMemoryReference.
    // https://forums.developer.apple.com/thread/88126
    
    func isRunning(bundleId: String) -> Bool {
        let apps = NSWorkspace.shared.runningApplications
        for app in apps {
            if app.bundleIdentifier == bundleId {
                return true
            }
        }
        return false
    }
    
    func isPlaying() -> Bool {
        let itunes: iTunesApplication! = SBApplication(bundleIdentifier: iTunesBundle)
        return itunes.playerState == .iTunesEPlSPlaying
    }
    
    func getCurrentTrack() -> iTunesTrack? {
        if isRunning(bundleId: iTunesBundle) {
            if isPlaying() {
                let itunes: iTunesApplication! = SBApplication(bundleIdentifier: iTunesBundle)
                let currentTrack = itunes.currentTrack
                return currentTrack
            }
        }
        return nil
    }
    
    func setRating(_ rating: Int) {
        if let currentTrack = getCurrentTrack() {
            currentTrack.setRating!(rating)
        }
    }
    
    func getRating() -> Int? {
        if let currentTrack = getCurrentTrack() {
            return currentTrack.rating
        }
        return nil
    }
    
}

enum Star {
    case none,one,two,three,four,five
    
    static func numStars(for rating: Int) -> Star {
        if rating == 0 {
            return .none
        } else if rating <= 20 {
            return .one
        } else if rating <= 40 {
            return .two
        } else if rating <= 60 {
            return .three
        } else if rating <= 80 {
            return .four
        } else if rating <= 100 {
            return .five
        }
        return .none
    }
}

