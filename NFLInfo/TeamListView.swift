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
    @Query(sort: \Team.id) var teams: [Team]
    

    var body: some View {
        List(teams) { team in
            HStack {
                Text(String(team.id))
                Text(team.name)
            }
        }
        .task {
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
