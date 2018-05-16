//
//  Utilities.swift
//  ScoreClock
//
//  Created by admin on 16/05/2018.
//  Copyright © 2018 WIT. All rights reserved.
//

import Foundation

class Utilities {
    
    static func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i.%02i", minutes, seconds)
    }
}
