//
//  AddTeamView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 8/1/23.
//

import Foundation
import SwiftUI

struct AddTeamView: View {
    let submitAction: (Team) -> Void
    @State var name: String = ""
    @State var location: String = ""
    public var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            TextField("Location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            CustomButtonView(action: {
                if let newURL = URL(string: "test") {
                    submitAction(.init(name: name, id: Int.random(in: 50...1000), url: newURL, location: location, players: []))
                }
            }, title: "Create Team")
        }
        .padding()

        
    }
    
    
}
