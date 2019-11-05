//
//  ContentView.swift
//  CycleTracksLA
//
//  Created by Horace Williams on 11/3/19.
//  Copyright © 2019 Horace Williams. All rights reserved.
//

import SwiftUI
import MapKit

let locationManager = CLLocationManager()

struct MapView: UIViewRepresentable {
    @Binding var locations: [MKUserLocation]
    @Binding var isRecording: Bool
    func updateUIView(_ view: MKMapView, context: Context) {
        if !isRecording {
            print("Not recording!")
            view.setUserTrackingMode(.none, animated: true)
            locationManager.stopUpdatingLocation()
        } else {
            view.setUserTrackingMode(.follow, animated: true)
        }
        print("update view")
        print("\(locations.count)")
        print("is recording: \(isRecording)")
    }

    typealias UIViewType = MKMapView

    func makeUIView(context: Context) -> MKMapView {
        locationManager.startUpdatingLocation()
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
            print("received location")
            if self.control.isRecording {
                control.locations.append(userLocation)
            }
        }

        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            print("view finished loading")
            mapView.showsUserLocation = true
        }
    }
}

struct MapView_Preview: PreviewProvider {
    @State static var locations: [MKUserLocation] = []
    @State static var isRecording = true
    static var previews: some View {
        MapView(locations: $locations, isRecording: $isRecording)
    }
}

struct ReviewRideView: View {
    @Binding var locations: [MKUserLocation]
    var body: some View {
        VStack {
            Text("Review \(locations.count) locations")
            Button("Submit Ride") {
                for location in self.locations {
                    print("\(location.location?.coordinate.latitude), \(location.location?.coordinate.longitude)")
                }
                print("submit!")
            }
        }
    }
}

struct RideView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var locations: [MKUserLocation]
    @State var isRecording: Bool = true
    @State var isPreviewing: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text("Recording Ride. \(locations.count) Locations.")
                NavigationLink(destination: ReviewRideView(locations: self.$locations), isActive: $isPreviewing) {
                    Text("Finish Ride")
                }
            }
            Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                Text("dismiss")
            }
            MapView(locations: $locations, isRecording: $isRecording).onDisappear {
                self.isRecording = false
            }.onAppear {
                self.isRecording = true
            }
        }
    }
}

struct ContentView: View {
    @State var rideModalExpanded = false
    @State var locations: [MKUserLocation] = []

    func showRideModal() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.rideModalExpanded = true
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Hello: \(rideModalExpanded ? "yes" : "no")")
                NavigationLink(destination: RideView(locations: self.$locations)) {
                    Text("Record Ride")
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
