//
//  SecondController.swift
//  TennisScoreboard
//
//  Created by Panja on 6/23/16.
//  Copyright © 2016 Panja. All rights reserved.
//

import Foundation
import UIKit

class SecondController: UIViewController {
    
    //Ad/No-Ad Button
    @IBOutlet weak var adSwitch: UISegmentedControl!
    @IBOutlet weak var setsTextBox: UITextField!
    
    @IBOutlet weak var tieBreakerSwitch: UISegmentedControl!
    
    
    var adds: Bool = true;
    var setsToWin: Int = 6;
    var tieBreaker: Bool = false;
    let shareData = ShareData.sharedInstance
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tieBreaker = defaults.boolForKey("tieBreaker")
        adds = defaults.boolForKey("adds")
        setsToWin = defaults.integerForKey("setsToWin")
        
        shareData.adds = adds
        shareData.setsToWin = setsToWin
        shareData.tieBreaker = tieBreaker
        
        if(adds){
            adSwitch.selectedSegmentIndex = 0;
        }else{
            adSwitch.selectedSegmentIndex = 1;
        }
        
        if(tieBreaker){
            tieBreakerSwitch.selectedSegmentIndex = 0;
        }else{
            tieBreakerSwitch.selectedSegmentIndex = 1;
        }
        setsTextBox.text = String(setsToWin);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func adButton(sender: AnyObject) {
        switch adSwitch.selectedSegmentIndex
        {
        case 0:
            print("Ads enabled");
            adds = true;
        case 1:
            print("Ads disabled");
            adds = false;
        default:
            break; 
        }
        shareData.adds = adds;
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(adds, forKey: "adds")
        defaults.synchronize()
    }
    
    @IBAction func tieBreakerButton(sender: AnyObject) {
        switch tieBreakerSwitch.selectedSegmentIndex
        {
        case 0:
            print("Tiebreakers Enabled")
            tieBreaker = true;
        case 1:
            print("Tiebreakers Disabled")
            tieBreaker = false;
        default:
            break;
        }
        shareData.tieBreaker = tieBreaker;
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tieBreaker, forKey: "tieBreaker")
        defaults.synchronize()
    }
    
    
    @IBAction func onSetNumberSubmit(sender: AnyObject) {
        shareData.setsToWin = Int(setsTextBox.text!)!;
        setsToWin = shareData.setsToWin;
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(setsToWin, forKey: "setsToWin")
        defaults.synchronize()
    }
    
    
}