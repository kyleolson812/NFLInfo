//
//  TeamDetailView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/24/23.
//

import Foundation
import SwiftUI
import SwiftData

struct TeamDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Player.id) var players: [Player]

    public init(team: Team) {
        self.team = team
    }
    var team: Team

    var body: some View {
        VStack {
            List(team.players, id: \.id) { player in
                HStack {
                    Text(String(player.id))
                    Text(player.name)
                }
            }
        }
    }
}
