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
        PageTabView(titles: ["TabA", "TabB", "TabC"]) {
            List {
                Text("xxxxxxxxxxxxxxxxxx").font(.headline)
                    .redacted(reason: .placeholder)
                Text("xxxxxxxxxxxxxxxxxx").font(.headline)
                    .redacted(reason: .placeholder)
                Text("xxxxxxxxxxxxxxxxxx").font(.headline)
                    .redacted(reason: .placeholder)
            }

            Color.green

            Color.blue
        }
        .edgesIgnoringSafeArea(.bottom)
        .accentColor(.yellow)
        .tint(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
