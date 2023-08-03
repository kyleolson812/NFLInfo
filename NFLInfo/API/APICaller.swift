//
//  APICaller.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import Foundation
import SwiftUI

// Define the API URL
let apiUrlString = "https://sports.core.api.espn.com/v2/sports/football/leagues/nfl/teams?limit=32"

public enum APIError: Error {
    case invalidAPI
    case noTeamsFound
    case footballAPINotFound
    case teamAPINotFound
    case teamDataError
}

public func fetchTeamData() async throws -> ([Team], [Player]) {
    // Create a URL object from the API URL string
    guard let apiUrl = URL(string: apiUrlString) else {
        throw APIError.invalidAPI
    }
    
    var newTeams = [Team]()
    var newPlayers = [Player]()
    
    let (data, _) = try await URLSession.shared.data(from: apiUrl)
                
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let teamsArray = json["items"] as? [[String: Any]] else { throw APIError.footballAPINotFound }
        
    for teams in teamsArray {
        guard let url = teams["$ref"] as? String,
              let apiUrl = URL(string: url) else { throw APIError.teamAPINotFound }
        
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let displayName = json["displayName"] as? String,
              let id = json["id"] as? String,
              let location = json["location"] as? String,
              let logos = json["logos"] as? [[String: Any]],
              let logo = logos.first,
              let logoURL = logo["href"] as? String,
              let athletes = json["athletes"] as? [String: Any],
              let athletesLink = athletes["$ref"] as? String
        else { throw APIError.teamDataError }
        
        if let newURL = URL(string: logoURL),
           let athletesURL = URL(string: athletesLink) {
            print(displayName)
            print(id)
            print(logoURL)
            let newTeam = Team(name: displayName, id: Int(id) ?? 999, url: newURL, location: location)
            let players = try await getPlayers(playerListLink: athletesURL, team: newTeam)

            newTeams.append(newTeam)
            newPlayers.append(contentsOf: players)
        }
    }
            
    return (newTeams, newPlayers)
}




public func getPlayers(playerListLink: URL, team: Team) async throws -> [Player] {
    var newPlayers = [Player]()
    let (data, _) = try await URLSession.shared.data(from: playerListLink)
    
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let playersLinkArray = json["items"] as? [[String: Any]]
    else { throw APIError.footballAPINotFound }
    
    for playerLink in playersLinkArray {
        if let playerLink = playerLink["$ref"] as? String,
           let apiUrl = URL(string: playerLink) {
            let (playerData, _) = try await URLSession.shared.data(from: apiUrl)
            
            guard let json = try JSONSerialization.jsonObject(with: playerData, options: []) as? [String: Any],
                  let name = json["fullName"] as? String,
                  let id = json["id"] as? String else { throw APIError.footballAPINotFound }
            
            newPlayers.append(.init(name: name, id: Int(id)!, team: team))
            

        }
        break
    }

    
    
    return newPlayers
}
