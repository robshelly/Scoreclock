//
//  Game.swift
//  ScoreClock
//
//  Created by admin on 26/04/2018.
//  Copyright © 2018 WIT. All rights reserved.
//

import Foundation

struct Game {
    var homeGoals: Int
    var awayGoals: Int



    mutating func goalScored(team: String) {
        if team == "home" {
            homeGoals += 1
        } else {
            awayGoals += 1
        }
    }
}
