//
//  Team.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import Foundation
import SwiftData

@Model
public class Team {
    public init(name: String) {
        self.name = name
    }
    
    var name: String
}
