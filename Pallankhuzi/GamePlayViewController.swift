//
//  GamePlayViewController.swift
//  Pallankhuzi
//
//  Created by Namit on 6/25/16.
//  Copyright © 2016 Namit. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController {
    enum playerType:Int{
        case Human, Bot
    }
    
    @IBOutlet weak var humanNameLabel: UILabel!
    @IBOutlet weak var humanScoreLabel: UILabel!
    @IBOutlet weak var botNameLabel: UILabel!
    @IBOutlet weak var botScoreLabel: UILabel!
    @IBOutlet weak var rollDiceButton: UIButton!
    @IBOutlet weak var diceNumberLabel: UILabel!
    
    @IBOutlet var humanPits: [UIView]!
    @IBOutlet var botPits: [UIView]!
    @IBOutlet var humanPitLabels: [UILabel]!
    @IBOutlet var botPitLabels: [UILabel]!
    @IBOutlet weak var gameTimerLabel: UILabel!
    @IBOutlet weak var die: DieView!
    
    let gameTimeInSec = 20.0
    var player:playerType = .Human
    var playerName:String?
    var roll:Int = 0
    var lastRowCount = 1
    var humanScore = 0
    var botScore = 0
    var gameIsOn = true
    var timer:NSTimer!
    var gameTimer:NSTimer!
    var gameTimeCounter:Double!
    var addPebbleTimer:NSTimer!
    var counter:Int = 0
    var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePitsRound()
        setupScoreLabels()
        startGame()
        diceNumberLabel.hidden = true
        gameTimeCounter = gameTimeInSec
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(updateGameTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func clickedRollDiceButton(sender: AnyObject) {
        rollDice()
        rollDiceButton.hidden = true
    }
    
    func rollDice(){
        diceNumberLabel.hidden = true
        timer.invalidate()
        roll = Int((arc4random() % 6) + 1);
        die.rollDie(roll)
        delay(2.0) { [weak self] in
                if let strongSelf = self{
                    strongSelf.diceNumberLabel.text = "\(strongSelf.roll)"
                    strongSelf.diceNumberLabel.hidden = false
                    if strongSelf.player == .Human{
                        strongSelf.timerForAddPebbleToHumanRows()
                        strongSelf.setupScoreLabels()
                    }
                    else{
                        strongSelf.timerForAddPebbleToBotRows()
                        strongSelf.setupScoreLabels()
                    }
            }
        }
    }
    
    func makePitsRound(){
        for pitView in humanPits {
            pitView.layer.cornerRadius = pitView.frame.size.width/2
            pitView.clipsToBounds = true
            pitView.layer.borderColor = UIColor.lightGrayColor().CGColor
            pitView.layer.borderWidth = 5.0
            pitView.backgroundColor = UIColor.clearColor()
        }
        
        for pitView in botPits {
            pitView.layer.cornerRadius = pitView.frame.size.width/2
            pitView.clipsToBounds = true
            pitView.layer.borderColor = UIColor.lightGrayColor().CGColor
            pitView.layer.borderWidth = 5.0
            pitView.backgroundColor = UIColor.clearColor()
        }
        
    }
    
    func setupScoreLabels(){
        for pitLabel in humanPitLabels{
            pitLabel.font = UIFont(name: "HelveticaNeue", size: 17)
            pitLabel.textColor = UIColor.blackColor()
        }
        
        for pitLabel in botPitLabels{
            pitLabel.font = UIFont(name: "HelveticaNeue", size: 17)
            pitLabel.textColor = UIColor.blackColor()
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func showHumanTurn(){
        humanNameLabel.text = String(format: "-> %@ -",playerName!)
        humanNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        humanScoreLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        botNameLabel.text = "Bot -"
        botNameLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        botScoreLabel.font = UIFont(name: "HelveticaNeue", size: 14)
    }
    
    func showBotTurn(){
        botNameLabel.text = "-> Bot -"
        botNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        botScoreLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        
        humanNameLabel.text = String(format: "%@ -",playerName!)
        humanNameLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        humanScoreLabel.font = UIFont(name: "HelveticaNeue", size: 14)
    }
    
    func timerForAddPebbleToHumanRows(){
        row = lastRowCount
        addPebbleTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(addPebblesToHumanRows), userInfo: nil, repeats: true)
        counter = 1
    }
    
    func timerForAddPebbleToBotRows(){
        row = lastRowCount
        addPebbleTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(addPebblesToBotRows), userInfo: nil, repeats: true)
        counter = 1
    }
    
    func addPebblesToHumanRows(){
        if counter <= roll{
            if(row > 7){
                row = 1
            }
            addPebblesToHumanRow(row)
            row += 1
            counter += 1
        }
        
        if counter > roll{
            addPebbleTimer.invalidate()
            lastRowCount = row
            if gameIsOn == true{
                botPlay()
            }
        }
    }
    
    func addPebblesToBotRows(){
        if counter <= roll{
            if(row > 7){
                row = 1
            }
            addPebblesToBotRow(row)
            row += 1
            counter += 1
        }
        
        if counter > roll{
            addPebbleTimer.invalidate()
            lastRowCount = row
            if gameIsOn == true {
                humanPlay()
            }
        }
    }
    
    func addPebblesToHumanRow(num:Int){
        for pitLabel in humanPitLabels{
            if pitLabel.tag == num{
                var count = Int(pitLabel.text!)!
                if count == 6{
                    humanScore += count
                    humanScoreLabel.text = "\(humanScore)"
                    count = 0
                }
                count += 1
                pitLabel.text = "\(count)"
                pitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
                pitLabel.textColor = UIColor.redColor()
                break
            }
        }
    }
    
    func addPebblesToBotRow(num:Int){
        for pitLabel in botPitLabels{
            if pitLabel.tag == num{
                var count = Int(pitLabel.text!)!
                if count == 6{
                    botScore += count
                    botScoreLabel.text = "\(botScore)"
                    count = 0
                }
                count += 1
                pitLabel.text = "\(count)"
                pitLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
                pitLabel.textColor = UIColor.redColor()
                break
            }
        }
    }
    
    func humanPlay(){
        rollDiceButton.hidden = false
        showHumanTurn()
        player = .Human
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(botPlay), userInfo: nil, repeats: false)
    }
    
    func botPlay(){
        rollDiceButton.hidden = true
        showBotTurn()
        player = .Bot
        rollDice()
    }
    
    func startGame(){
        humanPlay()
    }
    
    func endGame(){
        gameTimer.invalidate()
        self.gameIsOn = false
        let defaults = NSUserDefaults.standardUserDefaults()
        if humanScore > botScore{
            defaults.setObject(String(format: "Winner - %@ - %d",playerName!,humanScore), forKey: "winner")
        }
        else if botScore > humanScore{
            defaults.setObject(String(format: "Winner - Bot - %d",botScore), forKey: "winner")
        }
        else{
            defaults.setObject("Game Draw", forKey: "winner")
        }
        defaults.synchronize()
        setHighscore(humanScore)
        showAlertWithTitle("Game Over", message: nil)
    }
    
    func setHighscore(num:Int){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let highscore = defaults.objectForKey("highscore") as? String{
            if Int(highscore) < num{
                defaults.setObject("\(num)", forKey: "highscore")
            }
        }
        else{
            defaults.setObject("\(num)", forKey: "highscore")
        }
        defaults.synchronize()
    }
    
    func showAlertWithTitle(title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateGameTime(){
        if gameTimeCounter != 0{
            gameTimeCounter = gameTimeCounter - 1
            gameTimerLabel.text = String(format: "Game Timer : %d",Int(gameTimeCounter))
        }
        else{
            self.endGame()
        }
    }
}
