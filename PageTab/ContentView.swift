//
//  ContentView.swift
//  PageTab
//
//  Created by Lova on 2021/9/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        PageTabView(titles: ["tabA", "tabB", "tabC"]) {
            Color.red.tag("try tag")

            Color.green

            Color.blue
        }
        .accentColor(.yellow)
        .tint(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}