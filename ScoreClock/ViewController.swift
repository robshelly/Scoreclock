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

    override func viewDidLoad() {
        super.viewDidLoad()

        game = Game()
        
        let btnLabels:[UILabel] = [timeLabel.titleLabel!, homeGoalLabel.titleLabel!, awayGoalLabel.titleLabel!]
        formatBtnLabels(btnLabels: btnLabels)
        
        timeLabel.setTitle(timeString(time: gameTime), for: .normal)
        updateGoalLabels()
    }
    
    func updateGoalLabels() {
        homeGoalLabel.setTitle(String(format: "%02d", game.homeGoals.count), for: .normal)
        awayGoalLabel.setTitle(String(format: "%02d", game.awayGoals.count), for: .normal)
    }
    
    @IBOutlet weak var timeLabel: UIButton!
    @IBOutlet weak var homeGoalLabel: UIButton!
    @IBOutlet weak var awayGoalLabel: UIButton!
    
    func formatBtnLabels(btnLabels: [UILabel]) {
        print("Formatting buttons")
        
        for lbl in btnLabels {
            lbl.numberOfLines = 1
            lbl.adjustsFontSizeToFitWidth = true
            lbl.baselineAdjustment = .alignCenters
            lbl.lineBreakMode = NSLineBreakMode.byClipping;
            lbl.font = UIFont(name:"Digital-7Mono", size: 200)
        }
    }
    
//    @IBAction func startTimer(_ sender: Any) {
//        if(isPlaying) {
//            return
//        }
//        gameClock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
//        isPlaying = true
//    }
//
//    @IBAction func pauseTimer(_ sender: Any) {
//        gameClock.invalidate()
//        isPlaying = false
//    }
//
//    @IBAction func resetTimer(_ sender: Any) {
//
//        gameClock.invalidate()
//        isPlaying = false
//        gameTime = 1200
//        timeLabel.setTitle(timeString(time: gameTime), for: .normal)
//    }
    
    @IBAction func toggleGameClock(_ sender: Any) {
        if isPlaying {
            gameClock.invalidate()
            isPlaying = false
        } else {
        gameClock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            isPlaying = true
        }
    }
    
    @objc func UpdateTimer() {
        gameTime -= 1
        
        // Prevent button flashing when text updates
        // https://stackoverflow.com/a/39071660
        UIView.performWithoutAnimation {
            timeLabel.setTitle(timeString(time: gameTime), for: .normal)
            timeLabel.layoutIfNeeded()
        }
    }
    @IBAction func testTweet(_ sender: Any) {
        // Tweeting using the Share functionality
        // https://www.youtube.com/watch?v=KxPavuI4t8o
        let activityController = UIActivityViewController(activityItems: ["Hello World"],
                                                          applicationActivities: nil)
        present(activityController, animated: true,  completion: nil)
    }
    
//    
//    func scoreGoal(team: String) {
//        
//        // Using popup box to get info from user
//        // https://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
//        let alert = UIAlertController(title: "Goal!", message: "Enter Player Number", preferredStyle: .alert)
//        alert.addTextField { (player) in
//            player.text = "Player"
//        }
//        alert.addAction(UIAlertAction(title: "Add Goal", style: .default, handler: { [weak alert] (_) in
//            let player = alert?.textFields![0].text
//            self.recordGoal(team: "home", player: player!)
//        }))
//        alert.addAction(UIAlertAction(title: "Add Goal and Share", style: .default, handler: { [weak alert] (_) in
//            let player = alert?.textFields![0].text
//            self.recordGoal(team: "home", player: player!)
//            self.shareGameStat(msg: "Goal Scored by \(player!)")
//            
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func recordGoal(team: String, player: String) {
//        print("Goal Scored by: " + player)
//        if (team == "home") {
//            game.homeGoals += 1
//            self.homeGoalLabel.setTitle(String(format: "%02d", game.homeGoals), for: .normal)
//        } else {
//            game.awayGoals += 1
//            self.awayGoalLabel.setTitle(String(format: "%02d", game.awayGoals), for: .normal)
//        }
//    }
//    
//    func shareGameStat(msg: String) {
//        let activityController = UIActivityViewController(activityItems: [msg],
//                                                          applicationActivities: nil)
//        present(activityController, animated: true,  completion: nil)
//    }
//
    
    @IBAction func scoreHomeGoal(_ sender: Any) {
        performSegue(withIdentifier: "goal", sender: sender)
    }
    
    @IBAction func scoreAwayGoal(_ sender: Any) {
        performSegue(withIdentifier: "goal", sender: sender)
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
        print("Unwinding")
        updateGoalLabels()
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i.%02i", minutes, seconds)
    }
}

