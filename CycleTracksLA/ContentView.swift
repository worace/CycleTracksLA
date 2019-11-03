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
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }

    typealias UIViewType = MKMapView

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
}

struct MapView_Preview: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct RideView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let message: String

    var body: some View {
        VStack {
            Text(message)
            Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
                Text("dismiss")
            }
            MapView()
        }
    }
}

struct ContentView: View {
    @State var rideModalExpanded = false
    var body: some View {
        VStack {
            Text("Hello: \(rideModalExpanded ? "yes" : "no")")
            Button(action: {self.rideModalExpanded = true}) {
                Text("Record Ride")
            }
        }.sheet(isPresented: $rideModalExpanded, onDismiss: {print("dismissed")}) {
            RideView(message: "Make a Ride")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
