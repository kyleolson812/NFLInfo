//
//  APICaller.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import Foundation

// Define the API URL
let apiUrlString = "https://site.api.espn.com/apis/site/v2/sports/football/nfl/teams"
let apiUrlString2 = "https://sports.core.api.espn.com/v2/sports/football/leagues/nfl/teams?limit=32"

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
                       let teamSlug = teamDict["slug"] as? String,
                       let teamID = teamDict["id"] as? String
                    {
//                        newTeams.append(Team(name: teamSlug, id: Int(teamID) ?? 999))
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

public func fetchTeamData2() async -> [Team] {
    // Create a URL object from the API URL string
    guard let apiUrl = URL(string: apiUrlString2) else {
        print("Invalid URL: \(apiUrlString)")
        exit(0)
    }
    
    
    var newTeams = [Team]()
    
    do {
        let (data, _) = try await URLSession.shared.data(from: apiUrl)
        do {
            // Convert the data to JSON

            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let teamsArr = json["items"] as? [[String: Any]] {
                for teams in teamsArr {
                    if let url = teams["$ref"] as? String {
                        guard let apiUrl = URL(string: url) else {
                            print("Invalid URL: \(apiUrlString)")
                            exit(0)
                        }
                        do {
                            let (data2, _) = try await URLSession.shared.data(from: apiUrl)
                            if let json2 = try JSONSerialization.jsonObject(with: data2, options: []) as? [String: Any],
                               let slug = json2["slug"] as? String,
                               let id = json2["id"] as? String,
                               let logos = json2["logos"] as? [[String: Any]],
                               let logo = logos.first,
                               let logoURL = logo["href"] as? String
                            {
                                if let newURL = URL(string: logoURL) {
                                    print(slug)
                                    print(id)
                                    print(logoURL)
                                    
                                    newTeams.append(Team(name: slug, id: Int(id) ?? 999, url: newURL))
                                }


//                                if let url = URL(string: "") {
//                                    newTeams.append(Team(name: slug, id: Int(id) ?? 999, url: url))
//                                }
                            }

                        } catch {
                            
                        }
                        
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
