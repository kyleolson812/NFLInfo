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
                AsyncImage(url: team.url) { image in
                    // Customize the image view using the loaded image
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20) // Adjust the frame size as needed
                } placeholder: {
                    // Placeholder view while the image is being loaded
                    Color.gray // You can use any view as a placeholder (e.g., a spinner, an activity indicator, etc.)
                }

            }
        }
        .task {
            let newTeams = await fetchTeamData2()
            for team in newTeams {
                modelContext.insert(team)
            }
        }
    }
}

#Preview {
    TeamListView()
}
