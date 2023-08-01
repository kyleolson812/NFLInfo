//
//  CustomButtonView.swift
//  NFLInfo
//
//  Created by Kyle Olson on 8/1/23.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        withAnimation {
            configuration.label
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(configuration.isPressed ? Color.gray : Color.blue)
                )
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}

struct CustomButtonView: View {
    let action: () -> Void
    let title: String
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
        }
        .buttonStyle(CustomButtonStyle())
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Welcome to My App")
                .font(.largeTitle)
                .padding(.bottom, 20)

            CustomButtonView(action: {
                print("hi!")
            }, title: "Tap Me")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
