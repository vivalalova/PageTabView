//
//  ContentView.swift
//  PageTab
//
//  Created by Lova on 2021/9/11.
//

import PageTabView
import SwiftUI

struct ContentView: View {
    var body: some View {
        PageTabView(titles: ["tabA", "tabB", "tabC"]) {
            Color.white

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
