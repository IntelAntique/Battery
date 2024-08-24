//
//  ContentView.swift
//  bad
//
//  Created by HAN YU FOONG on 8/20/24.
//

import SwiftUI
import UIKit
import UserNotifications
import MapKit

struct MapView: View {
    let manager = CLLocationManager()
    @State private var cam: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        Map(position: $cam){
            UserAnnotation()
        }
        .onAppear(){
            manager.requestWhenInUseAuthorization()
        }
        .mapControls{
            MapUserLocationButton()
        }
    }
}

struct ContentView: View {
    var status: [String] = ["Idle", 
                            "Charging",
                            "Charged"]
    
//    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @State private var allowed: BooleanLiteralType = false
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
//        MapView()
        NavigationView{
            ScrollView{
                NavigationLink("Location", destination: MapView())
                HStack{
                    Menu(UIDevice.current.name) {
                        NavigationLink("Location", destination: Other())
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
            .navigationTitle("Devices")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .padding()
    }
}

struct Other: View{
    var body: some View{
        ZStack{
            Color.green.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .navigationTitle("GreenScreen")
        }
    }
}

#Preview {
    ContentView()
}
