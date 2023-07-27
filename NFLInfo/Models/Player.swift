//
//  Player.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/27/23.
//

import Foundation
import SwiftData

@Model
public class Player {
    public init(name: String, id: Int, team: Team) {
        self.name = name
        self.id = id
        self.team = team
    }
    
    @Attribute(.unique) public var id: Int
    @Relationship(.nullify, inverse: \Team.players)
    var team: Team?
    var name: String

}
