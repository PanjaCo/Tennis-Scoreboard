//
//  ShareData.swift
//  TennisScoreboard
//
//  Created by Panja on 6/23/16.
//  Copyright © 2016 Panja. All rights reserved.
//

import Foundation

class ShareData {
    class var sharedInstance: ShareData {
        struct Static {
            static var instance: ShareData?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ShareData()
        }
        
        return Static.instance!
    }

    var positions = [""] //Positions Array
    
    var someString : String! //Some String
    
    var selectedTheme : AnyObject! //Some Object
    
    var adds : Bool! = true; //Some Boolean
    
    var tieBreaker: Bool = true;
    
    var setsToWin: Int = 6;
    
    
    //Saving variables even after the app is closed and re-opened
}