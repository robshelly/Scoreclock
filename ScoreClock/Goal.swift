//
//  Goal.swift
//  ScoreClock
//
//  Created by admin on 15/05/2018.
//  Copyright © 2018 WIT. All rights reserved.
//

import Foundation

struct Goal {
    var scorer: String!
    var assist1: String!
    var assist2: String!
    
    init(scorer: String? = nil, assist1: String? = nil, assist2: String? = nil) {
        self.scorer = scorer
        self.assist1 = assist1
        self.assist2 = assist2
    }
}

