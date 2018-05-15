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

        print("Segued to GoalVC")
        print("Time: \(gameTime)")
        print("Scoring Team \(scoringTeam)")
    }
    
    @IBOutlet weak var scorer: UITextField!
    @IBOutlet weak var assist1: UITextField!
    @IBOutlet weak var assist2: UITextField!
    
    
    func addGoal() {
        
        if !(scorer.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            scoringPlayer = scorer.text?.trimmingCharacters(in: .whitespaces)
        }
        if !(assist1.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            assist1Player = assist1.text?.trimmingCharacters(in: .whitespaces)
        }
        if !(assist2.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            assist2Player = assist2.text?.trimmingCharacters(in: .whitespaces)
        }
        
        if !((scoringPlayer) != nil) {
            game.goalScored(team: scoringTeam)
        }
    }
    
    
    @IBAction func saveGoal(_ sender: Any) {
        self.addGoal()
        self.performSegue(withIdentifier: "exitGoal", sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "exitGoal", sender: self)
    }
    
}
