//
//  iTunesBridge.swift
//

import AppKit
import ScriptingBridge

@objc protocol iTunesApplication {
    @objc optional var currentTrack: iTunesTrack {get set}
    @objc optional var name: NSString {get}
}


extension SBApplication: iTunesApplication {}

// an item
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

