//
//  TeamListView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import Foundation
import SwiftData
import SwiftUI

struct TeamListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Team.id) var teams: [Team]
    @Query(sort: \Player.id) var players: [Player]

    @Binding var presentSideMenu: Bool

    /// Sheet to create a new team.
    @State private var showingSheet = false
    @State private var showList = true

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if !showList {
                        ProgressView()
                    } else {
                        withAnimation {
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
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation {
                            presentSideMenu.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .padding()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            showingSheet.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                    }
                }
            }
            .task {
                if true {
                    showList = false
                    do {
                        for team in teams {
                            modelContext.delete(team)
                        }
                        for player in players {
                            modelContext.delete(player)
                        }
                        try modelContext.save()
                    } catch {
                        print("Error: Failed to properly delete initial teams.")
                    }

                    do {
                        let newItems = try await fetchData()

                        for team in newItems.0 {
                            modelContext.insert(team)
                        }
                        for player in newItems.0 {
                            modelContext.insert(player)
                        }
                    } catch {
                        print(error)
                    }
                    showList = true
                }
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
        NavigationLink(destination: TeamDetailView(team: team)) {
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
