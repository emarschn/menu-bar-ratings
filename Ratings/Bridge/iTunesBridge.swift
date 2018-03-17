//
//  iTunesBridge.swift
//

import AppKit
import ScriptingBridge

@objc enum iTunesEPlS: NSInteger {
    case iTunesEPlSStopped = 0x6b505353
    case iTunesEPlSPlaying = 0x6b505350
    case iTunesEPlSPaused = 0x6b505370
    case iTunesEPlSFastForwarding = 0x6b505346
    case iTunesEPlSRewinding = 0x6b505352
}

@objc protocol iTunesApplication {
    @objc optional var currentTrack: iTunesTrack {get set}
    @objc optional var name: NSString {get}
    
    @objc optional var playerState: iTunesEPlS {get}
}


extension SBApplication: iTunesApplication {}

@objc protocol iTunesItem {
    @objc optional var container: SBObject {get}
    @objc optional func id() -> NSInteger
    @objc optional var index: NSInteger {get}
    @objc optional var name: NSString {get set}
    @objc optional var persistentID: NSString {get}
    @objc optional var properties: NSDictionary {get set}
    @objc optional func reveal()
}

extension SBObject: iTunesItem {}

@objc protocol iTunesTrack: iTunesItem {
    
    @objc optional var rating: Int {get}
    @objc optional func setRating(_: Int)

}

extension SBObject: iTunesTrack {}

