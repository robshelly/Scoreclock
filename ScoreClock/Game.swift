//
//  Game.swift
//  ScoreClock
//
//  Created by admin on 26/04/2018.
//  Copyright © 2018 WIT. All rights reserved.
//

import Foundation

struct Game {
    var homeTeam: String?
    var awayTeam: String?
    var homeGoals: [Goal]
    var awayGoals: [Goal]
    
    // Optional initialisation parameters
    // https://medium.com/@sergueivinnitskii/easy-struct-initialization-in-swift-8ee46b8d84d5
    init(homeTeam: String? = "Home", awayTeam: String? = "Away") {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        homeGoals = []
        awayGoals = []
    }


    mutating func goalScored(team: String, scorer: String? = nil, assist1: String? = nil, assist2: String? = nil) {
        if team == "home" {
            homeGoals.append(Goal(scorer: scorer, assist1: assist1, assist2: assist2))
        } else {
            awayGoals.append(Goal(scorer: scorer, assist1: assist1, assist2: assist2))
        }
    }
    
}
