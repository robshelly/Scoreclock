//
//  GoalVC.swift
//  ScoreClock
//
//  Created by admin on 15/05/2018.
//  Copyright © 2018 WIT. All rights reserved.
//

import UIKit

// Programmatically Unwind
// https://www.andrewcbancroft.com/2015/12/18/working-with-unwind-segues-programmatically-in-swift/

class GoalVC: UIViewController {
    
    var scoringTeam: String!
    var scoringPlayer: String!
    var assist1Player: String!
    var assist2Player: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatToolbar()
        formatTextFields()
        
        // Changing txtField placholder colour
        // https://stackoverflow.com/a/47118192
        scorer.attributedPlaceholder = NSAttributedString(string: "Player", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        assist1.attributedPlaceholder = NSAttributedString(string: "First Assist", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        assist2.attributedPlaceholder = NSAttributedString(string: "Second Assist", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])

    }
    
    @IBOutlet weak var scorer: UITextField!
    @IBOutlet weak var assist1: UITextField!
    @IBOutlet weak var assist2: UITextField!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    func getTextFieldValues() {
        if !(scorer.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            scoringPlayer = scorer.text?.trimmingCharacters(in: .whitespaces)
        }
        if !(assist1.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            assist1Player = assist1.text?.trimmingCharacters(in: .whitespaces)
        }
        if !(assist2.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            assist2Player = assist2.text?.trimmingCharacters(in: .whitespaces)
        }
    }
    
    func addGoal() {
        // If there's no player in Scoring field, just record goal but no stats
        if !((scoringPlayer) != nil) {
            game.goalScored(team: scoringTeam)
            
            // If there's a player in scoring field but no assists
            // Record unassisted goal
        } else if !((assist1Player) != nil) {
            game.goalScored(team: scoringTeam, scorer: scoringPlayer)
            
            // Else record goal scorer and assisting player(s)
        } else {
            game.goalScored(team: scoringTeam, scorer: scoringPlayer, assist1: assist1Player, assist2: assist2Player)
        }
    }
    
    func getGoalStat() -> String {
        var goalStat = "Goal!\n"
        // Add scoring team
        goalStat += (scoringTeam == "home") ? "\(game.homeTeam!)" : "\(game.awayTeam!)"
        goalStat += " @ \(Utilities.timeString(time: gameTime))"
        
        // Add Scoring player
        if ((scoringPlayer) != nil) {
            goalStat += "\n\(scoringPlayer!)"
        
            // Add assists
            goalStat += ((assist1Player) != nil) ? "\nAssists: \(assist1Player!)" : " (Unassisted)"
            goalStat += ((assist2Player) != nil) ? ", \(assist2Player!)" : ""
        
            let activityController = UIActivityViewController(
                activityItems: [goalStat], applicationActivities: nil)
            present(activityController, animated: true,  completion: nil)
        } else {
        }
        print("Goal Stat: \n \(goalStat)")
        return goalStat
    }
    
    func formatToolbar() {
        for btn in [share, save, cancel]  {
            btn!.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Digital-7", size: 24)!], for: UIControlState.normal)
        }
    }
    
    func formatTextFields() {
        // Changing some textfield attributes
        // https://stackoverflow.com/questions/1861527/uitextfield-border-color
        for field in [scorer,assist1,assist2] {
            field!.layer.borderWidth = 1
            field!.layer.cornerRadius=8.0
            field!.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func saveGoal(_ sender: Any) {
        self.getTextFieldValues()
        self.addGoal()
        self.performSegue(withIdentifier: "exitGoal", sender: self)
    }
    
    @IBAction func share(_ sender: Any) {
        self.getTextFieldValues()
        let activityController = UIActivityViewController(
            activityItems: [getGoalStat()], applicationActivities: nil)
        present(activityController, animated: true,  completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "exitGoal", sender: self)
    }
    
}
