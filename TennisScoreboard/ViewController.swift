//
//  ViewController.swift
//  TennisScoreboard
//
//  Created by Panja on 6/22/16.
//  Copyright © 2016 Panja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Window
    
    
    
    //Users Score of Games/Sets/Points
    @IBOutlet weak var oneGame: UILabel!
    @IBOutlet weak var twoGame: UILabel!
    @IBOutlet weak var oneSet: UILabel!
    @IBOutlet weak var twoSet: UILabel!
    @IBOutlet weak var onePoint: UILabel!
    @IBOutlet weak var twoPoint: UILabel!
    
    
    
    //Switch Sides
    @IBOutlet weak var switchSidesText: UILabel!
    @IBOutlet weak var switchSidesImage: UIImageView!
    
    //Time Label
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseLabel: UIButton!
    
    //Start Game
    @IBOutlet weak var startGame: UIButton!
    
    //Serving Selection
    @IBOutlet weak var servingSelectionLabel: UILabel!
    @IBOutlet weak var servingLeftSelection: UIButton!
    @IBOutlet weak var servingRightSelection: UIButton!
    
    //Serving Images
    @IBOutlet weak var leftServingImage: UIImageView!
    @IBOutlet weak var rightServingImage: UIImageView!
    
    
    //Point Selection
    @IBOutlet weak var leftPoint: UIButton!
    @IBOutlet weak var rightPoint: UIButton!
    
    @IBOutlet weak var settingsButtonOverlay: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    //Variables
    var seconds = 0;
    var minutes = 0;
    var pauseTimer = false
    
    
    
    //Player/Team One Points/Sets
    var oneP: Int = 0;
    var onePT: String = "0";
    var oneG: Int = 0;
    var oneGT: String = "0";
    var oneS: Int = 0;
    var oneST: String = "0";
    var oneServing: Bool = false;
    
    
    //Player/Team Two Points/Sets
    var twoP: Int = 0;
    var twoPT: String = "0";
    var twoG: Int = 0;
    var twoGT: String = "0";
    var twoS: Int = 0;
    var twoST: String = "0";
    var twoServing: Bool = false;
    
    //Share Variables Between Files
    var adds: Bool = true;
    var setsToWin: Int = 6;
    var tieBreaker: Bool = false;
    let shareData = ShareData.sharedInstance
    
    var tieBreakerEnabled: Bool = false;
    var oneTie: Int = 0;
    var oneTieT: String = "0"
    var twoTie: Int = 0;
    var twoTieT: String = "0"
    var tieServer: Int = 0;
    
    @IBOutlet weak var addLabel: UILabel!
    
    var pickServer: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        tieBreaker = defaults.boolForKey("tieBreaker")
        adds = defaults.boolForKey("adds")
        setsToWin = defaults.integerForKey("setsToWin")

        
        self.automaticallyAdjustsScrollViewInsets = true;
        
        self.shareData.tieBreaker = tieBreaker
        self.shareData.adds = adds
        self.shareData.setsToWin = setsToWin
        
        
        timeLabel.hidden = true;
        oneGame.hidden = true;
        twoGame.hidden = true;
        oneSet.hidden = true;
        twoSet.hidden = true;
        switchSidesImage.hidden = true;
        switchSidesText.hidden = true;
        pauseLabel.hidden = true;
        oneGame.hidden = true;
        twoGame.hidden = true;
        servingRightSelection.hidden = true;
        servingLeftSelection.hidden = true;
        servingSelectionLabel.hidden = true;
        leftPoint.hidden = true;
        rightPoint.hidden = true;
        onePoint.hidden = true;
        twoPoint.hidden = true;
        addLabel.hidden = true;
        
        rightServingImage.hidden = true;
        leftServingImage.hidden = true;
        
        settingsButtonOverlay.hidden = false;
        
        restartButton.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onStart(sender: AnyObject) {
        
        if(pickServer){
            switchSidesText.hidden = true;
            switchSidesImage.hidden = true;
            timeLabel.hidden = false;
            oneGame.hidden = false;
            twoGame.hidden = false;
            oneSet.hidden = false;
            twoSet.hidden = false;
            startGame.hidden = true;
            pauseLabel.hidden = false;
            oneGame.hidden = false;
            twoGame.hidden = false;
            servingSelectionLabel.hidden = true;
            servingLeftSelection.hidden = true;
            servingRightSelection.hidden = true;
            leftPoint.hidden = false;
            rightPoint.hidden = false;
            onePoint.hidden = false;
            twoPoint.hidden = false;
            addLabel.hidden = false;
            addLabel.text = "";
            
            rightServingImage.image = UIImage(named: "tennisBall.png");
            leftServingImage.image = UIImage(named: "tennisBall.png");
            
            settingsButtonOverlay.hidden = false;
            

            var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        }else{
            servingSelectionLabel.hidden = false;
            servingLeftSelection.hidden = false;
            servingRightSelection.hidden = false;
            startGame.hidden = true;
        }
    }
    
    @IBAction func oneServerSelected(sender: AnyObject) {
        oneServing = true;
        twoServing = false;
        leftServingImage.hidden = false;
        rightServingImage.hidden = true;
        pickServer = true;
        onStart("");
    }
    @IBAction func twoServerSelection(sender: AnyObject) {
        oneServing = false;
        twoServing = true;
        leftServingImage.hidden = true;
        rightServingImage.hidden = false;
        pickServer = true;
        onStart("");
    }
    
    
    
    
    
    @IBAction func onLeftPoint(sender: AnyObject) {
        if(tieBreakerEnabled){
            oneTie += 1
            tieBreakerFunc()
        }else{
            oneP += 1
            setScore()
        }
    }
    @IBAction func onRightPoint(sender: AnyObject) {
        if(tieBreakerEnabled){
            twoTie += 1
            tieBreakerFunc()
        }else{
            twoP += 1
            setScore()
        }
        
    }
    
    
    @IBAction func onPause(sender: AnyObject) {
        if(pauseTimer){
            pauseTimer = false
            //pauseLabel.setTitle("Pause", forState: .Normal);
            pauseLabel.setImage(UIImage(named: "pauseIcon.png"), forState: .Normal);
        }else{
            pauseTimer = true
            //pauseLabel.setTitle("Resume", forState: .Normal);
            pauseLabel.setImage(UIImage(named: "playIcon.png"), forState: .Normal);
        }
    }
    
    func timerUpdate(){
        if !(pauseTimer){
            seconds += 1
            var Splaceholder = "";
            var Mplaceholder = "";
            if(seconds == 60){
                minutes += 1;
                seconds = 0;
            }
            if(seconds < 10){
                Splaceholder = "0"
            }
            if(minutes < 10){
                Mplaceholder = "0"
            }
        
            var combo = Mplaceholder + String(minutes) + ":" + Splaceholder + String(seconds)
            timeLabel.text = combo;
        
        }
    
    }

    func setScore(){
        //print("One in SetScore: " + String(oneP));
        //print("Two in SetSCore: " + String(twoP));
        if(oneP == twoP && oneP >= 4){
            oneP = 3
            twoP = 3
        }
        if(oneP == 1){
            onePT = "15"
        }else if(oneP == 2){
            onePT = "30"
        }else if(oneP == 3){
            onePT = "40"
        }
        if(twoP == 1){
            twoPT = "15"
        }else if(twoP == 2){
            twoPT = "30"
        }else if(twoP == 3){
            twoPT = "40"
        }
        if(oneP == twoP && oneP == 3){
            onePT = "Duece"
            twoPT = "Duece"
            addLabel.text = ""
        }
        if(oneP == 4 && twoP == 3 && adds == true){
            oneP = 4
            twoP = 3
            if(oneServing){
                onePT = ""
                addLabel.text = "Add-In"
                twoPT = ""
            }else{
                onePT = ""
                addLabel.text = "Add-Out"
                twoPT = ""
            }
        }else if(twoP == 4 && oneP == 3 && adds == true){
            twoP = 4
            oneP = 3
            if(twoServing){
                twoPT = ""
                addLabel.text = "Add-In"
                onePT = ""
            }else{
                twoPT = ""
                addLabel.text = "Add-Out"
                onePT = ""
            }
        }
        if(oneP == twoP && oneP == 3){
            oneP = 3;
            twoP = 3;
            onePT = "Deuce"
            twoPT = "Duece"
            addLabel.text = ""
            
        }
        if(oneP == 5 && twoP == 3){
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            oneG += 1
            oneGT = String(oneG);
            //Win Statement
            if(oneG == 6 && twoG == 6 && tieBreaker){
                tieBreakerEnabled = true
            }else if(oneG == 6 && twoG == 5 && tieBreaker){
               
            }else if(oneG == 7 && twoG == 5 && tieBreaker){
                oneG = 0
                oneGT = "0"
                twoG = 0
                twoGT = "0"
                oneS += 1;
                oneST = String(oneS)
            }else if(oneG == 6){
                oneG = 0;
                oneGT = "0"
                twoG = 0;
                twoGT = "0"
                oneS += 1;
                oneST = String(oneS);
            }
            addLabel.text = ""
            if(oneServing){
                rightServingImage.hidden = false;
                leftServingImage.hidden = true;
                oneServing = false;
                twoServing = true;
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = true;
                    leftServingImage.hidden = false;
                    oneServing = true;
                    twoServing = false;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    
                    var temp = oneGame;
                    var tempTwo = oneSet;
                    oneGame = twoGame;
                    oneSet = twoSet;
                    twoGame = temp;
                    twoSet = tempTwo;
                }
                
            }else{
                rightServingImage.hidden = true;
                leftServingImage.hidden = false;
                oneServing = true;
                twoServing = false;
                if((oneG + twoG) % 2 == 0){
                    rightServingImage.hidden = false;
                    leftServingImage.hidden = true;
                    oneServing = false;
                    twoServing = true;
                    
                    //Initiate 5 second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerThree = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
                
            }
            oneGT = String(oneG)
        }else if(twoP == 5 && oneP == 3){
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            twoG += 1
            twoGT = String(twoG)
            //Win Statement
            if(twoG == 6 && oneG == 6 && tieBreaker){
                tieBreakerEnabled = true
            }else if(twoG == 6 && oneG == 5 && tieBreaker){
                
            }else if(twoG == 7 && oneG == 5 && tieBreaker){
                oneG = 0
                oneGT = "0"
                twoG = 0
                twoGT = "0"
                twoS += 1;
                twoST = String(twoS)
            }else if(twoG == 6){
                oneG = 0;
                oneGT = "0"
                twoG = 0;
                twoGT = "0"
                twoS += 1;
                twoST = String(twoS);
            }
            addLabel.text = ""
            if(oneServing){
                rightServingImage.hidden = false;
                leftServingImage.hidden = true;
                oneServing = false;
                twoServing = true;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = true;
                    leftServingImage.hidden = false;
                    oneServing = true;
                    twoServing = false;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }else{
                rightServingImage.hidden = true;
                leftServingImage.hidden = false;
                oneServing = true;
                twoServing = false;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = false;
                    leftServingImage.hidden = true;
                    oneServing = false;
                    twoServing = true;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }
            twoGT = String(twoG)
        }
        if(oneP == 4 && twoP <= 2){
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            oneG += 1
            oneGT = String(oneG);
            //Win Statement
            if(oneG == 6 && twoG == 6 && tieBreaker){
                tieBreakerEnabled = true
            }else if(oneG == 6 && twoG == 5 && tieBreaker){
                
            }else if(oneG == 7 && twoG == 5 && tieBreaker){
                oneG = 0
                oneGT = "0"
                twoG = 0
                twoGT = "0"
                oneS += 1;
                oneST = String(oneS)
            }else if(oneG == 6){
                oneG = 0
                oneGT = "0"
                twoG = 0;
                twoGT = "0"
                oneS += 1
                oneST = String(oneS)
            }
            if(oneServing){
                rightServingImage.hidden = false;
                leftServingImage.hidden = true;
                oneServing = false;
                twoServing = true;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = true;
                    leftServingImage.hidden = false;
                    oneServing = true;
                    twoServing = false;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }else{
                rightServingImage.hidden = true;
                leftServingImage.hidden = false;
                oneServing = true;
                twoServing = false;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = false;
                    leftServingImage.hidden = true;
                    oneServing = false;
                    twoServing = true;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }
        }else if(twoP == 4 && oneP <= 2){
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            twoG += 1
            twoGT = String(twoG)
            //Win Statement
            if(oneG == 6 && twoG == 6 && tieBreaker){
                tieBreakerEnabled = true
            }else if(twoG == 6 && oneG == 5 && tieBreaker){
                
            }else if(twoG == 7 && oneG == 5 && tieBreaker){
                oneG = 0
                oneGT = "0"
                twoG = 0
                twoGT = "0"
                twoS += 1;
                twoST = String(twoS)
            }else if(twoG == 6){
                oneG = 0
                oneGT = "0"
                twoG = 0;
                twoGT = "0"
                twoS += 1
                twoST = String(twoS)
            }
            if(oneServing){
                rightServingImage.hidden = false;
                leftServingImage.hidden = true;
                oneServing = false;
                twoServing = true;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = true;
                    leftServingImage.hidden = false;
                    oneServing = true;
                    twoServing = false;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }else{
                rightServingImage.hidden = true;
                leftServingImage.hidden = false;
                oneServing = true;
                twoServing = false;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = false;
                    leftServingImage.hidden = true;
                    oneServing = false;
                    twoServing = true;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }
        }
        if(oneP == 4 && adds == false){
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            oneG += 1
            oneGT = String(oneG)
            //Win Statement
            if(oneG == 6 && twoG == 6 && tieBreaker){
                tieBreakerEnabled = true
            }else if(oneG == 6 && twoG == 5 && tieBreaker){
                
            }else if(oneG == 7 && twoG == 5 && tieBreaker){
                oneG = 0
                oneGT = "0"
                twoG = 0
                twoGT = "0"
                oneS += 1;
                oneST = String(oneS)
            }else if(twoG == 6){
                oneG = 0
                oneGT = "0"
                twoG = 0;
                twoGT = "0"
                oneS += 1
                oneST = String(oneS)
            }
            if(oneServing){
                rightServingImage.hidden = false;
                leftServingImage.hidden = true;
                oneServing = false;
                twoServing = true;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = true;
                    leftServingImage.hidden = false;
                    oneServing = true;
                    twoServing = false;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }else{
                rightServingImage.hidden = true;
                leftServingImage.hidden = false;
                oneServing = true;
                twoServing = false;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = false;
                    leftServingImage.hidden = true;
                    oneServing = false;
                    twoServing = true;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }
        }else if(twoP == 4 && adds == false){
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            twoG += 1
            twoGT = String(twoG)
            //Win Statement
            if(oneG == 6 && twoG == 6 && tieBreaker){
                tieBreakerEnabled = true
            }else if(twoG == 6 && oneG == 5 && tieBreaker){
                
            }else if(twoG == 7 && oneG == 5 && tieBreaker){
                oneG = 0
                oneGT = "0"
                twoG = 0
                twoGT = "0"
                twoS += 1;
                twoST = String(twoS)
            }else if(twoG == 6){
                oneG = 0
                oneGT = "0"
                twoG = 0;
                twoGT = "0"
                twoS += 1
                twoST = String(twoS)
            }
            if(oneServing){
                rightServingImage.hidden = false;
                leftServingImage.hidden = true;
                oneServing = false;
                twoServing = true;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = true;
                    leftServingImage.hidden = false;
                    oneServing = true;
                    twoServing = false;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }else{
                rightServingImage.hidden = true;
                leftServingImage.hidden = false;
                oneServing = true;
                twoServing = false;
                
                if((oneG + twoG) % 2 != 0){
                    rightServingImage.hidden = false;
                    leftServingImage.hidden = true;
                    oneServing = false;
                    twoServing = true;
                    
                    //Initiate 5 Second Timer
                    switchSidesText.hidden = false;
                    switchSidesImage.hidden = false;
                    var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                    var temp = oneG;
                    var tempTwo = oneS;
                    oneG = twoG;
                    oneS = twoS;
                    twoG = temp;
                    twoS = tempTwo;
                }
            }
        }
        
        onePoint.text = onePT;
        twoPoint.text = twoPT;
        oneGame.text = oneGT;
        twoGame.text = twoGT;
        oneSet.text = oneST;
        twoSet.text = twoST;
        checkWin()
    }
    func checkWin(){
        if(oneS == setsToWin){
            //Player One Has Won
            addLabel.text = "Player 1 Has Won"
            //Clear Board
            clearBoard()
        }
        if(twoS == setsToWin){
            //Player Two Has Won
            addLabel.text = "Player 2 Has Won"
            //Clear Board
            clearBoard()
        }
    }
    
    func tieBreakerFunc(){
        if((oneTie + twoTie) % 2 != 0){
            if(oneServing){
                leftServingImage.hidden = true;
                rightServingImage.hidden = false;
                oneServing = false;
                twoServing = true;
            }else{
                leftServingImage.hidden = false;
                rightServingImage.hidden = true;
                oneServing = true;
                twoServing = false;
            }
            tieServer += 1
        }
        if(tieServer == 2){
            if(oneServing){
                leftServingImage.hidden = true;
                rightServingImage.hidden = false;
                oneServing = false;
                twoServing = true;
                switchSidesText.hidden = false;
                switchSidesImage.hidden = false;
                var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                var temp = oneTie;
                var tempTwo = oneS;
                oneTie = twoTie;
                oneS = twoS;
                twoTie = temp;
                twoS = tempTwo;
            }else{
                leftServingImage.hidden = false;
                rightServingImage.hidden = true;
                oneServing = true;
                twoServing = false;
                switchSidesText.hidden = false;
                switchSidesImage.hidden = false;
                var timerTwo = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(clearSwitch), userInfo: nil, repeats: false)
                var temp = oneG;
                var tempTwo = oneS;
                oneG = twoG;
                oneS = twoS;
                twoG = temp;
                twoS = tempTwo;
            }
            tieServer = 0;
        }
        if(oneTie == 7){
            oneTie = 0;
            oneTieT = "0"
            twoTie = 0
            twoTieT = "0"
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            oneG = 0;
            oneGT = "0"
            twoG = 0;
            twoGT = "0"
            oneS += 1;
            oneST = String(oneS);
            tieBreakerEnabled = false
            //Check Win Func
            checkWin()
        }else{
            oneTieT = String(oneTie)
        }
        if(twoTie == 7){
            oneTie = 0
            oneTieT = "0"
            twoTie = 0
            twoTieT = "0"
            oneP = 0;
            twoP = 0;
            onePT = "0"
            twoPT = "0"
            oneG = 0;
            oneGT = "0"
            twoG = 0;
            twoGT = "0"
            twoS += 1;
            twoST = String(twoS);
            tieBreakerEnabled = false
            //Check Win Func
            checkWin()
        }else{
            twoTieT = String(twoTie)
        }
        
        onePoint.text = oneTieT;
        twoPoint.text = twoTieT;
        oneGame.text = oneGT;
        twoGame.text = twoGT;
        oneSet.text = oneST;
        twoSet.text = twoST;
    }
    
    func clearBoard(){
        timeLabel.hidden = true;
        oneGame.hidden = true;
        twoGame.hidden = true;
        oneSet.hidden = true;
        twoSet.hidden = true;
        switchSidesImage.hidden = true;
        switchSidesText.hidden = true;
        pauseLabel.hidden = true;
        oneGame.hidden = true;
        twoGame.hidden = true;
        servingRightSelection.hidden = true;
        servingLeftSelection.hidden = true;
        servingSelectionLabel.hidden = true;
        leftPoint.hidden = true;
        rightPoint.hidden = true;
        onePoint.hidden = true;
        twoPoint.hidden = true;
        //addLabel.hidden = true;
        
        rightServingImage.hidden = true;
        leftServingImage.hidden = true;
        
        settingsButtonOverlay.hidden = true;
        
        restartButton.hidden = false;
    }
    
    @IBAction func onRestartButton(sender: AnyObject) {
        //self.window.contentViewController = newContentViewController;
        
    }
    
    func clearSwitch(){
        switchSidesText.hidden = true;
        switchSidesImage.hidden = true;
    }
    
    
    //TODO
    
    //Add the switch sides image
        //Make the server image not switch when the sides are being switched
}


