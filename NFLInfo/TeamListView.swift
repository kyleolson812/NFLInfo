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
    @State private var showingSheet = false

    var body: some View {
        NavigationView {
            VStack {
                List(teams, id: \.id) { team in
                    teamRow(team: team)
                        .swipeActions {
                            Button(role: .destructive) {
                                print("Deleting team: \(team.name)")
                                modelContext.delete(team)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                }
                .task {
                    do {
                        let newTeams = try await fetchTeamData()
                        for team in newTeams {
                            modelContext.insert(team)
                        }
                    } catch let error {
                        print(error)
                    }
                }
                CustomButtonView(action: {
                    showingSheet = true
                }, title: "Create Team")
            }
            .sheet(isPresented: $showingSheet) {
                AddTeamView { team in
                    modelContext.insert(team)
                    showingSheet = false
                }
            }
        }
    }
    
    @ViewBuilder func teamRow(team: Team) -> some View {
        NavigationLink(destination: TeamDetailView()) {
            HStack {
                Text(String(team.id))
                Text(team.name)
                AsyncImage(url: team.url) { image in
                    // Customize the image view using the loaded image
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30) // Adjust the frame size as needed
                } placeholder: {
                    // Placeholder view while the image is being loaded
                    Color.gray // You can use any view as a placeholder (e.g., a spinner, an activity indicator, etc.)
                }
            }
        }
    }
}

#Preview {
    TeamListView()
}
