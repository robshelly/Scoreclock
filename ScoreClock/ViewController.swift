//
//  ViewController.swift
//  ScoreClock
//
//  Created by admin on 12/04/2018.
//  Copyright © 2018 WIT. All rights reserved.
//


//Turorials used:
// https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f

import UIKit

var game: Game!
var gameTime:TimeInterval = 1200
var gameClock:Timer = Timer()
var isPlaying:Bool = false

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        game = Game(homeGoals: 0, awayGoals: 0)
    
        // Rezise font to fill label
        timeLabel.titleLabel?.numberOfLines = 1
        timeLabel.titleLabel?.adjustsFontSizeToFitWidth = true
        timeLabel.titleLabel?.baselineAdjustment = .alignCenters
        timeLabel.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping;
//        timeLabel.titleLabel?.font = UIFont(name:"Segment7", size: 200)
        timeLabel.titleLabel?.font = UIFont(name:"Digital-7Mono", size: 200)
        
        timeLabel.setTitle(timeString(time: gameTime), for: .normal)
        homeGoalLabel.setTitle("\(game.homeGoals)", for: .normal)
        awayGoalLabel.setTitle("\(game.awayGoals)", for: .normal)
    }

    @IBOutlet weak var timeLabel: UIButton!
    @IBOutlet weak var homeGoalLabel: UIButton!
    @IBOutlet weak var awayGoalLabel: UIButton!
    
    @IBAction func startTimer(_ sender: Any) {
        if(isPlaying) {
            return
        }
        gameClock = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    @IBAction func pauseTimer(_ sender: Any) {
        
        gameClock.invalidate()
        isPlaying = false
    }
    
    @IBAction func resetTimer(_ sender: Any) {
        
        gameClock.invalidate()
        isPlaying = false
        gameTime = 1200
        timeLabel.setTitle(timeString(time: gameTime), for: .normal)
    }
    
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
    
    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i.%02i", minutes, seconds)
    }
}

