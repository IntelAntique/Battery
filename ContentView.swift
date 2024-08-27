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
    
    init() {
//        let appearance = UINavigationBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.shadowColor = .clear
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//            UINavigationBar.appearance().standardAppearance = appearance
//            
//            UITabBar.appearance().barTintColor = UIColor.white
//            UITabBar.appearance().backgroundColor = UIColor.white
//            UITabBar.appearance().shadowImage = UIImage()
//            UITabBar.appearance().backgroundImage = UIImage()
//            
//            UINavigationBar.appearance().isTranslucent = false
//            UIToolbar.appearance().backgroundColor = UIColor.white
//            UIToolbar.appearance().isTranslucent = false
//            UIToolbar.appearance().setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    var status: [String] = ["Idle",
                            "Charging",
                            "Charged"]
    
    
    
    @State private var allowed: BooleanLiteralType = false
    
    func notified(title: String, subtitle: String, seconds: Int) {
        if(allowed == false){
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
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
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State private var healthy = true
    
    var body: some View {
        NavigationStack{
            ScrollView{
                HStack{
                    Menu(UIDevice.current.name) {
                        NavigationLink("Location", destination: MapView())
                        Button("Notify", action: {
                            notified(title: "Check Battery", subtitle: "Battery advice from a friend", seconds: 0)
                        })
                        

                        Text("Status: " + status[0])
                        Text(UUID().uuidString)
                    }
                    Image(systemName: "battery.50")
                    Image(systemName: "wifi")
                        .symbolEffect(.variableColor.reversing)
                }
                Divider()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Toggle(isOn: $healthy){
                        Text("Auto")
                    }
                    .onChange(of: healthy) {old, new in
                        UIDevice.current.isBatteryMonitoringEnabled = new
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Image(systemName:"heart.fill")
                }
            }
            .navigationTitle("Devices")
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .ignoresSafeArea(.all)
        .onReceive(timer) { time in
            if(healthy) {
                if(UIDevice.current.batteryLevel >= 0.8){
                    notified(title: "Overcharged", subtitle: "Unplug for battery health", seconds: 0)
                }
                if(UIDevice.current.batteryLevel <= 0.4){
                    notified(title: "Undercharged", subtitle: "Time to plug in", seconds: 0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
