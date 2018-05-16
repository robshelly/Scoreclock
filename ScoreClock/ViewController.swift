//
//  ViewController.swift
//  ScoreClock
//
//  Created by admin on 12/04/2018.
//  Copyright © 2018 WIT. All rights reserved.
//


//Turorials used:
// Basic Stopwatch funtionality
// https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f
// Sending Tweets
// https://www.youtube.com/watch?v=B_x-ccc8Iuc
// Segue
// https://www.youtube.com/watch?v=XjBqKaGiZws
// https://stackoverflow.com/a/42856839

import UIKit
import Social

var game: Game!
var gameTime:TimeInterval = 1200
var gameClock:Timer = Timer()
var isPlaying:Bool = false

class ViewController: UIViewController {
    
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var timeLabel: UIButton!
    @IBOutlet weak var homeGoalLabel: UIButton!
    @IBOutlet weak var awayGoalLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialise Game
        game = Game()
        
        // Format Game clock
        timeLabel.setTitle(Utilities.timeString(time: gameTime), for: .normal)
        
        // Format some UI elements
        formatBtnLabels()
        updateGoalLabels()
        
        // Add actions for tap and hold to buttons
        addButtonActions()
    }
    
    func addButtonActions() {
        // Single button with two actions for tap and hold
        // https://stackoverflow.com/a/30859297
        // https://stackoverflow.com/a/36160191
        // Execute only once on long press
        // https://www.ioscreator.com/tutorials/long-press-gesture-ios-tutorial-ios11
        
        addHomeGoalActions()
        addAwayGoalActions()
        addTimeActions()
    }
    
    func addHomeGoalActions() {
        let tapHomeGoal = UITapGestureRecognizer(target: self, action: #selector(self.scoreHomeGoal))
        let holdHomeGoal = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteHomeGoal))
        homeGoalLabel.addGestureRecognizer(tapHomeGoal)
        homeGoalLabel.addGestureRecognizer(holdHomeGoal)
    }
    
    func addAwayGoalActions() {
        let tapAwayGoal = UITapGestureRecognizer(target: self, action: #selector(self.scoreAwayGoal))
        let holdAwayGoal = UILongPressGestureRecognizer(target: self, action: #selector(self.deleteAwayGoal))
        awayGoalLabel.addGestureRecognizer(tapAwayGoal)
        awayGoalLabel.addGestureRecognizer(holdAwayGoal)
    }
    
    func addTimeActions() {
        let tapTime = UITapGestureRecognizer(target: self, action: #selector(self.toggleClock))
        let holdTime = UILongPressGestureRecognizer(target: self, action: #selector(self.setClock))
        timeLabel.addGestureRecognizer(tapTime)
        timeLabel.addGestureRecognizer(holdTime)
    }
    
    @objc func scoreHomeGoal() {
        performSegue(withIdentifier: "goal", sender: homeGoalLabel)
    }
    
    @objc func deleteHomeGoal(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            deleteGoal(team: "home")
        }
    }
    
    @objc func scoreAwayGoal() {
        performSegue(withIdentifier: "goal", sender: awayGoalLabel)
    }
    
    @objc func deleteAwayGoal(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            deleteGoal(team: "away")
        }
    }
    
    func deleteGoal(team: String) {
        if team == "home" {
            if game.homeGoals.count > 0 { game.homeGoals.removeLast() }
        } else {
            if game.awayGoals.count > 0 { game.awayGoals.removeLast() }
        }
        updateGoalLabels()
    }
    
    @objc func setClock(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            // User input from alert box
            // https://stackoverflow.com/a/26567485
            let alert = UIAlertController(title: "Set Time", message: "Set period time (minutes)", preferredStyle: .alert)

            alert.addTextField { (minutes) in
                minutes.text = "20"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let minutes = alert?.textFields![0].text // Force unwrapping because we know it exists.
                // Gettings Doubl from optional string
                // https://stackoverflow.com/a/46989179
                guard let minutesString = minutes else { return }
                let mins = Double(minutesString)
                if (mins != nil) {
                    self.setGameClock(time: mins!)
                } else {
                    print("Wrong input")
                }
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func toggleClock() {
        if isPlaying {
            gameClock.invalidate()
            isPlaying = false
        } else {
            gameClock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            isPlaying = true
        }
    }
    
    func setBorderColours() {
        // Can't set border colour of buttons in User Defined Attributes so set here instead
        // See https://stackoverflow.com/a/15010440
        // Other border attributes set in User Defined Runtime Attributes
        // https://stackoverflow.com/a/30091664
        for btn in [timeLabel, homeGoalLabel, awayGoalLabel] {
            btn?.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    func formatBtnLabels() {
        let btnLabels:[UILabel] = [timeLabel.titleLabel!, homeGoalLabel.titleLabel!, awayGoalLabel.titleLabel!]
        for lbl in btnLabels {
            lbl.numberOfLines = 1
            lbl.adjustsFontSizeToFitWidth = true
            lbl.baselineAdjustment = .alignCenters
            lbl.lineBreakMode = NSLineBreakMode.byClipping;
            // set font very big and it will be scaled down to fit
            // if it's set smaller (therefore already fits) it won't scale up
            lbl.font = UIFont(name:"Digital-7Mono", size: 200)
        }
        setBorderColours()
    }
    
    func updateGoalLabels() {
        homeGoalLabel.setTitle(String(format: "%02d", game.homeGoals.count), for: .normal)
        awayGoalLabel.setTitle(String(format: "%02d", game.awayGoals.count), for: .normal)
    }
    
    func setGameClock(time: TimeInterval) {
        gameClock.invalidate()
        gameTime = time * 60
        timeLabel.setTitle(Utilities.timeString(time: gameTime), for: .normal)
    }
    
    @objc func UpdateTimer() {
        gameTime -= 1
        
        if gameTime == 0 {
            gameClock.invalidate()
            // TODO other stuff too
        }
        
        // Prevent button flashing when text updates
        // https://stackoverflow.com/a/39071660
        UIView.performWithoutAnimation {
            timeLabel.setTitle(Utilities.timeString(time: gameTime), for: .normal)
            timeLabel.layoutIfNeeded()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let goalVC = segue.destination as? GoalVC else { return }
        goalVC.scoringTeam = "home"
        if (sender as! UIButton) == self.homeGoalLabel {
            goalVC.scoringTeam = "home"
        } else {
            goalVC.scoringTeam = "away"
        }
        
    }
    
    @IBAction func didUnwindFromGoalVc(_ sender: UIStoryboardSegue) {
        updateGoalLabels()
    }
}

