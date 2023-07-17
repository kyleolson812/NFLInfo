//
//  APICaller.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import Foundation

// Define the API URL
let apiUrlString = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/teams"

public func fetchTeamData() async -> [Team] {
    // Create a URL object from the API URL string
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid URL: \(apiUrlString)")
        exit(0)
    }
    
    var newTeams = [Team]()
    
    do {
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        do {
            // Convert the data to JSON

            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let sportsArr = json["sports"] as? [[String: Any]],
               let sportsDict = sportsArr.first,
               let leaguesArr = sportsDict["leagues"] as? [[String: Any]],
               let leaguesDict = leaguesArr.first,
               let teamsArr = leaguesDict["teams"] as? [[String: Any]]
            {
                for team in teamsArr {
                    if let teamDict = team["team"] as? [String: Any],
                       let teamSlug = teamDict["slug"] as? String
                    {
                        newTeams.append(Team(name: teamSlug))
                    }
                }
                return newTeams
            }
        } catch {
            print("JSON serialization error: \(error.localizedDescription)")
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    return []
}
