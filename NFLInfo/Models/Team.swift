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
    public init(name: String, id: Int, url: URL, location: String) {
        self.name = name
        self.id = id
        self.url = url
        self.location = location
    }
    
    @Attribute(.unique) public var id: Int
    var url: URL
    var name: String
    var players: [Player]
    var location: String = ""
}
