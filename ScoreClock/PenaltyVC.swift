//
//  PenaltyVC.swift
//  ScoreClock
//
//  Created by Karolina Chalupska on 17/05/2018.
//  Copyright © 2018 WIT. All rights reserved.
//

import UIKit

class PenaltyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        formatToolbar()
//        formatTextFields()
        formatBtnLabels()
        
        homeGoals.setTitle(String(format: "%02d", game.homeGoals.count), for: .normal)
        awayGoals.setTitle(String(format: "%02d", game.awayGoals.count), for: .normal)
        time.setTitle(Utilities.timeString(time: gameTime), for: .normal)
    }
    
    @IBOutlet weak var homeGoals: UIButton!
    @IBOutlet weak var awayGoals: UIButton!
    @IBOutlet weak var time: UIButton!
    
    
//    func formatToolbar() {
//        for btn in [share, save, cancel]  {
//            btn!.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "Digital-7", size: 24)!], for: UIControlState.normal)
//        }
//    }
//
//    func formatTextFields() {
//        // Changing some textfield attributes
//        // https://stackoverflow.com/questions/1861527/uitextfield-border-color
//        for field in [scorer,assist1,assist2] {
//            field!.layer.borderWidth = 1
//            field!.layer.cornerRadius=8.0
//            field!.layer.borderColor = UIColor.white.cgColor
//        }
//    
//        // Changing txtField placholder colour
//        // https://stackoverflow.com/a/47118192
//        scorer.attributedPlaceholder = NSAttributedString(string: "Player", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
//        assist1.attributedPlaceholder = NSAttributedString(string: "First Assist", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
//        assist2.attributedPlaceholder = NSAttributedString(string: "Second Assist", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
//    }
    
    func formatBtnLabels() {
        let btnLabels:[UILabel] = [time.titleLabel!, homeGoals.titleLabel!, awayGoals.titleLabel!]
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
    
    func setBorderColours() {
        for btn in [time, homeGoals, awayGoals] {
            btn?.layer.borderColor = UIColor.white.cgColor
        }
    }

}
