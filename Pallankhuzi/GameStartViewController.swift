//
//  GameStartViewController.swift
//  Pallankhuzi
//
//  Created by Namit on 6/25/16.
//  Copyright © 2016 Namit. All rights reserved.
//

import UIKit

class GameStartViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    var gamePlayed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winnerLabel.hidden = true
        highScoreLabel.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if gamePlayed == true{
            if let winner = defaults.objectForKey("winner") as? String{
                winnerLabel.text = winner
                winnerLabel.hidden = false
                defaults.removeObjectForKey("winner")
            }
        }
        if let highScore = defaults.objectForKey("highscore") as? String{
            highScoreLabel.text = "Highscore: \(highScore)"
            highScoreLabel.hidden = false
        }
        defaults.synchronize()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        gamePlayed = true
        view.endEditing(true)
        if nameTextField.text?.characters.count > 0{
            let controller = segue.destinationViewController as! GamePlayViewController
            controller.playerName = nameTextField.text
        }
        else{
            showAlertWithTitle("Error", message: "Name field empty!")
        }
    }
    
    func showAlertWithTitle(title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
