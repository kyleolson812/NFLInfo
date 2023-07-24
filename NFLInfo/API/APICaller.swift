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

public func fetchTeamData() async throws -> [Team] {
    // Create a URL object from the API URL string
    guard let apiUrl = URL(string: apiUrlString) else {
        throw APIError.invalidAPI
    }
    
    var newTeams = [Team]()
    
    let (data, _) = try await URLSession.shared.data(from: apiUrl)
                
    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
          let teamsArray = json["items"] as? [[String: Any]] else { throw APIError.footballAPINotFound }
        
    for teams in teamsArray {
        guard let url = teams["$ref"] as? String,
              let apiUrl = URL(string: url) else { throw APIError.teamAPINotFound }
        
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let slug = json["slug"] as? String,
              let id = json["id"] as? String,
              let logos = json["logos"] as? [[String: Any]],
              let logo = logos.first,
              let logoURL = logo["href"] as? String else { throw APIError.teamDataError }
                    
        if let newURL = URL(string: logoURL) {
            print(slug)
            print(id)
            print(logoURL)
                            
            newTeams.append(Team(name: slug, id: Int(id) ?? 999, url: newURL))
        }
    }
            
    return newTeams
}

// old code
// public func fetchTeamData() async -> [Team] {
//    // Create a URL object from the API URL string
//    guard let apiUrl = URL(string: apiUrlString) else {
//        print("Invalid URL: \(apiUrlString)")
//        exit(0)
//    }
//
//    var newTeams = [Team]()
//
//    do {
//        let (data, _) = try await URLSession.shared.data(from: apiUrl)
//        do {
//            // Convert the data to JSON
//
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//               let sportsArr = json["sports"] as? [[String: Any]],
//               let sportsDict = sportsArr.first,
//               let leaguesArr = sportsDict["leagues"] as? [[String: Any]],
//               let leaguesDict = leaguesArr.first,
//               let teamsArr = leaguesDict["teams"] as? [[String: Any]]
//            {
//                for team in teamsArr {
//                    if let teamDict = team["team"] as? [String: Any],
//                       let teamSlug = teamDict["slug"] as? String,
//                       let teamID = teamDict["id"] as? String
//                    {
////                        newTeams.append(Team(name: teamSlug, id: Int(teamID) ?? 999))
//                    }
//                }
//                return newTeams
//            }
//        } catch {
//            print("JSON serialization error: \(error.localizedDescription)")
//        }
//    } catch {
//        print("Error: \(error.localizedDescription)")
//    }
//    return []
// }
