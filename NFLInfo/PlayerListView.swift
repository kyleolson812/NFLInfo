//
//  PlayerListView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 8/4/23.
//

import Foundation
import SwiftData
import SwiftUI

struct PlayerListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Team.id) var teams: [Team]
    @Query(sort: \Player.name) var players: [Player]
    
    @Binding var presentSideMenu: Bool

    var body: some View {
        NavigationStack {
            VStack {
                List(players, id: \.id) { player in
                    Text("ID: \(String(player.id)) Name: \(player.name)")
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
                        print("Add Tapped!")
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                    }
                }
            }
        }
    }
}
