//
//  TeamDetailView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/24/23.
//

import Foundation
import SwiftUI

struct TeamDetailView: View {
    public init(team: Team) {
        self.team = team
    }
    var team: Team

    var body: some View {
        VStack {
            Text("Detail View!")
            List(team.players, id: \.id) { player in
                HStack {
                    Text(String(player.id))
                    Text(player.name)
                }
            }
        }
    }
}
