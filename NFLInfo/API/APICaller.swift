//
//  APICaller.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import Foundation
import SwiftUI

// TODO: Hit API and loop through pages for athletes.
///http://sports.core.api.espn.com/v2/sports/football/leagues/nfl/seasons/2023/teams/1/athletes?page=3&lang=en&region=us

// Define the API URL
let footballUrlString = "https://sports.core.api.espn.com/v2/sports/football/leagues/nfl/teams?limit=32"

public enum APIError: Error {
    case invalidApi
    case noTeamsFound
    case footballApiNotFound
    case teamApiNotFound
    case athletesApiNotFound
    case playerApiNotFound
    case teamDataError
    case playerDataError
}

/// Gets the data related to the NFL application.
/// - Throws: Some error related to retrieving information.
/// - Returns: An array of teams in the NFL, and an array of players in the NFL.
public func fetchData() async throws -> ([Team], [Player]) {
    // Create a URL object from the API URL string
    guard let footballURL = URL(string: footballUrlString) else { throw APIError.invalidApi }
    
    var newTeams = [Team]()
    var newPlayers = [Player]()
    
    let (data, _) = try await URLSession.shared.data(from: footballURL)
                
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let teamsArray = json["items"] as? [[String: Any]] else { throw APIError.footballApiNotFound }
        
    for teams in teamsArray {
        // Create a URL object from the API URL string
        guard let teamUrlString = teams["$ref"] as? String,
              let teamURL = URL(string: teamUrlString)
        else {
            throw APIError.teamApiNotFound
        }
        let newTeamData = try await getTeam(teamURL: teamURL)
        newTeams.append(newTeamData.0)
        newPlayers.append(contentsOf: newTeamData.1)
    }
    
    return (newTeams, newPlayers)
}

/// Retrieve the teams from the API.
/// - Parameter teamURL: The URL for the respective team.
/// - Throws: An error related to getting the team information.
/// - Returns: A singular team with players attached.
public func getTeam(teamURL: URL) async throws -> (Team, [Player]) {
    let (data, _) = try await URLSession.shared.data(from: teamURL)
    
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let displayName = json["displayName"] as? String,
          let id = json["id"] as? String,
          let location = json["location"] as? String,
          let logos = json["logos"] as? [[String: Any]],
          let logo = logos.first,
          let logoURL = logo["href"] as? String,
          let athletes = json["athletes"] as? [String: Any],
          let athletesUrlString = athletes["$ref"] as? String,
          let newURL = URL(string: logoURL),
          let athletesURL = URL(string: athletesUrlString)
    else { throw APIError.teamDataError }
    
    let newTeam = Team(name: displayName, id: Int(id) ?? 999, url: newURL, location: location)
    let newPlayers = try await getPlayers(athletesURL: athletesURL, team: newTeam)
    newTeam.players = newPlayers
    print("ID: \(newTeam.id) New Team: \(newTeam.name)")
    return (newTeam, newPlayers)
}

/// Retrieve the players from a given team from the API.
/// - Parameter athletesURL: The URL for the players of a team.
/// - Throws: An error related to getting the player information.
/// - Returns: An array of players.
public func getPlayers(athletesURL: URL, team: Team) async throws -> [Player] {
    var newPlayers = [Player]()
    let (data, _) = try await URLSession.shared.data(from: athletesURL)
    
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let playersLinkArray = json["items"] as? [[String: Any]]
    else { throw APIError.athletesApiNotFound }
    
    for playerLink in playersLinkArray {
        guard let playerLink = playerLink["$ref"] as? String,
              let apiUrl = URL(string: playerLink) else { throw APIError.playerApiNotFound }
        
        let (playerData, _) = try await URLSession.shared.data(from: apiUrl)
            
        guard let json = try JSONSerialization.jsonObject(with: playerData, options: []) as? [String: Any],
              let name = json["fullName"] as? String,
              let id = json["id"] as? String else { throw APIError.playerDataError }
            
        newPlayers.append(.init(name: name, id: Int(id) ?? 999, team: team))
        // Uncomment this break when you want to use all players. This is pretty expensive thanks api >:(
         break
    }

    return newPlayers
}
