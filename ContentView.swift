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
    var status: [String] = ["Idle", 
                            "Charging",
                            "Charged"]
    @State private var allowed: BooleanLiteralType = false
    
    func location() { }
    func notified() {
        if(allowed == false){
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                    allowed = true
                } else if let error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Check Battery"
        content.subtitle = "Battery advice from a friend"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    var body: some View {
        VStack{
            HStack{
                Menu(UIDevice.current.name) {
                    Button("Location", action: location)
                    Button("Notify", action: notified)
                    Text("Status: " + status[0])
                }
//                Text(UUID().uuidString)
                Image(systemName: "battery.50")
                Image(systemName: "wifi")
//                    .symbolEffect(.bounce, value: 1)
                    .symbolEffect(.variableColor.reversing)
            }
            Divider()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
