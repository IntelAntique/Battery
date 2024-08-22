//
//  ContentView.swift
//  bad
//
//  Created by HAN YU FOONG on 8/20/24.
//

import SwiftUI
import UIKit
import UserNotifications

struct ContentView: View {
    var body: some View {
        VStack{
            HStack{
                Text(UIDevice.current.name)
//                Text(UUID().uuidString)
                Image(systemName: "battery.50")
//                    .symbolEffect(.variableColor.reversing)
            }
            Divider()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
