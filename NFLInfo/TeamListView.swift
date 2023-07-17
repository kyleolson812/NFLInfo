//
//  TeamListView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import Foundation
import SwiftUI
import SwiftData

struct TeamListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var teams: [Team]
    
    var body: some View {
        List(teams) { team in
            Text(team.name)
        }
        .task {
            for team in teams {
                modelContext.delete(team)
            }
            let newTeams = await fetchTeamData()
            for team in newTeams {
                modelContext.insert(team)
            }
        }
    }
}

#Preview {
    TeamListView()
}
