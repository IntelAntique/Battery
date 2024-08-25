//
//  MapView.swift
//  BatteryCheck
//
//  Created by HAN YU FOONG on 8/24/24.
//

import Foundation
import MapKit
import SwiftUI

struct MapView: View {
    let manager = CLLocationManager()
    @State private var cam: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        ZStack{
            Map(position: $cam){
                UserAnnotation()
            }
            .onAppear(){
                manager.requestWhenInUseAuthorization()
            }
            .mapControls{
                MapUserLocationButton()
            }
            .toolbarBackground(
                Color.clear,
                for: .navigationBar, .tabBar)
        }
    }
}
