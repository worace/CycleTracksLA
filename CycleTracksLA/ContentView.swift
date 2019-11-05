//
//  ContentView.swift
//  CycleTracksLA
//
//  Created by Horace Williams on 11/3/19.
//  Copyright © 2019 Horace Williams. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var locations: [MKUserLocation]
    func updateUIView(_ view: MKMapView, context: Context) {
        view.setUserTrackingMode(.follow, animated: true)
    }

    typealias UIViewType = MKMapView

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView

        init(_ control: MapView) {
            self.control = control
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            print("*** updated user location")
            print("\(userLocation)")
            control.locations.append(userLocation)
        }

        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            print("view finished loading")
            mapView.setUserTrackingMode(.follow, animated: true)
            mapView.showsUserLocation = true
        }
    }
}

struct MapView_Preview: PreviewProvider {
    @State static var locations: [MKUserLocation] = []
    static var previews: some View {
        MapView(locations: $locations)
    }
}

struct RideView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var locations: [MKUserLocation] = []

    var body: some View {
        VStack {
            Text("Recording Ride. \(locations.count) Locations.")
            Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                Text("dismiss")
            }
            MapView(locations: $locations)
        }
    }
}

struct ContentView: View {
    @State var rideModalExpanded = false
    let locationManager = CLLocationManager()

    func showRideModal() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.rideModalExpanded = true
        }
    }

    var body: some View {
        VStack {
            Text("Hello: \(rideModalExpanded ? "yes" : "no")")
            Button(action: self.showRideModal) {
                Text("Record Ride")
            }
        }.sheet(isPresented: $rideModalExpanded, onDismiss: {print("dismissed")}) {
            RideView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
