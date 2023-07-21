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
    public init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    @Attribute(.unique) public var id: Int
    var name: String
}
