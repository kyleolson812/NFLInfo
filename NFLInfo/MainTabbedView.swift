//
//  MainTabbedView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 8/4/23.
//

import SwiftUI

struct MainTabbedView: View {
    @Environment(\.modelContext) private var modelContext
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
            ZStack{
                
                TabView(selection: $selectedSideMenuTab) {
                    TeamListView(presentSideMenu: $presentSideMenu)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(0)
                    PlayerListView(presentSideMenu: $presentSideMenu)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(1)
                }
                
                
                
                SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
            }


        
    }
}
