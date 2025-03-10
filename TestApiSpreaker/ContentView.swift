//
//  ContentView.swift
//  TestApiSpreaker
//
//  Created by Giovanni Fioretto on 10/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("canepizza")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
            Text("Qui metterò il titolo del podcast")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
