//
//  MyFriendsView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/25/21.
//

import SwiftUI
import MapKit
import FirebaseDatabase

let friend = Update()
struct FriendMapView: UIViewRepresentable {
    @State var centerCoordinate = CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496)
//    @EnvironmentObject var locationData: LocationData
    @State var passedLat : Double
    @State var passedLong : Double
    @State var passedName : String
    @State var passedPhone : String
    let mapView = MKMapView()
//    let friend = Update()
    let p1 = MKPointAnnotation()
    let newPoint = MKPointAnnotation()
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
    
        //let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
        let region = MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        
        //Add a marker to where we're going:
        
        p1.coordinate = CLLocationCoordinate2D(latitude: passedLat, longitude: passedLong)
        p1.title = passedName
        mapView.addAnnotation(p1)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let updateLat = friend.getLatData(username: passedPhone)
        let updateLong = friend.getLongData(username: passedPhone)
        view.removeAnnotations(view.annotations)
        newPoint.coordinate = CLLocationCoordinate2D(latitude: updateLat, longitude: updateLong)
        newPoint.title = passedName
        view.addAnnotation(newPoint)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: FriendMapView

        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: FriendMapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }

        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            //do nothing
        }
    }
}

struct MyFriendsView: View {
    @ObservedObject private var locationManager = LocationManager()
    @State private var didTapContact: Bool = false
    @State private var errorNotSharing: Bool = false
    var cons : [Contact]
    var body: some View {
        var selectedName : String = ""
        var selectedPhone: String = ""
        var lat : Double = 0.0
        var long : Double = 0.0
        List(cons){ contact in
            ContactRow(contact: contact)
                .onTapGesture{
                    selectedName = contact.name
                    selectedPhone = contact.phoneNumber
                    lat = friend.getLatData(username: contact.phoneNumber)
                    long = friend.getLongData(username: contact.phoneNumber)
                    if(lat == 91.0){
                        self.errorNotSharing.toggle()
                    }
                    else {
                        self.didTapContact.toggle()
                    }
            }
        }
        .alert(isPresented: $errorNotSharing, content: {
            Alert(title: Text("Error"), message: Text("This friend is not currently sending their location to you")
                  , dismissButton: .default(Text("Ok"), action: {
                    self.errorNotSharing.toggle()
                  }))
        })
        .sheet(isPresented: $didTapContact){
            VStack {
                FriendMapView(passedLat: lat, passedLong: long, passedName: selectedName, passedPhone: selectedPhone)
                Button(action: {self.didTapContact.toggle()}, label: {
                    Text("Done")
                        .padding(9)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .background(Color.blue)
                })
            }
        }
    }
}

//struct MyFriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyFriendsView().environmentObject(ModelData())
//    }
//}


