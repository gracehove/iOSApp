//
//  PathView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI
import UIKit
import MapKit

/** DEFINES BIG MAP!!! */

struct PathMapView: UIViewRepresentable {
    @State var centerCoordinate = CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496)
    
    var passedLocation : Location

    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
    
        //let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
        let region = MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        
        
        //Add a marker to where we're going:
        let p2 = MKPlacemark(coordinate: passedLocation.coordinate)
        let p1 = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        
        
    
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([p1,p2])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        }
        
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    //print(#function)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: PathMapView

        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: PathMapView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }

        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            //do nothing
        }
    }
}

/** REGULAR PATH DEVIATION */
struct PathView: View {
    @ObservedObject private var manager = LocationManager()
    @State var interrupted : Bool = false
    @State var end : Bool = false
    @State var update : String = ""
    @State var startingRadius : Double = 0
    @State var currentRadius : Double = 0
    
    var passedContact: Contact
    var passedLocation: Location
    
    private func run(){
        let coordinate = self.manager.center
        //RUN DA CODE
        DispatchQueue.global(qos: .userInteractive).async {
            sleep (1) //gimmie a second to catch up!
            
            
            
            //Inform user that you are starting the path deviation function:
            let sms = "sms: \(passedContact.phoneNumber)&body=I'm walking back to \(passedLocation.description) with the Path Deviation function. My current location is http://www.google.com/maps/place/\(coordinate.latitude),\(coordinate.longitude)"
            let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            
            //ESTABLISH A STARTING POINT
            startingRadius = MKMapPoint(manager.center).distance(to: MKMapPoint(passedLocation.coordinate))
            currentRadius = startingRadius
            
            //Monitor progress until user arrives at destination
            while(MKMapPoint(manager.center).distance(to: MKMapPoint(passedLocation.coordinate)) > 30){
                //END IF USER WANTS TO END
                if(end){
                    //Inform user that you are ending the expect me function:
                    let sms = "sms: \(passedContact.phoneNumber)&body=I have ended the Path Deviation function."
                    let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                    break
                }
                //Sleep until next test:
                sleep (30)
                
                //TEST THE RADIUS:
                //User isn't moving at all?
                if((abs(startingRadius - currentRadius)) < 15){
                    //Inform user that you are ending the expect me function:
                    let sms = "sms: \(passedContact.phoneNumber)&body=I'm walking back to \(passedLocation.description) with the Path Deviation function and seem to have stopped. My current location is http://www.google.com/maps/place/\(coordinate.latitude),\(coordinate.longitude)"
                    let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                    
                } else if ( currentRadius > (startingRadius + 20)){ //Going the wrong way?
                    //Inform user that you are ending the expect me function:
                    let sms = "sms: \(passedContact.phoneNumber)&body=I'm walking back to \(passedLocation.description) with the Path Deviation function and seem to be going in the wrong direction. My current location is http://www.google.com/maps/place/\(coordinate.latitude),\(coordinate.longitude)"
                    let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                }
                //Update these guys:
                startingRadius = currentRadius
                currentRadius = MKMapPoint(manager.center).distance(to: MKMapPoint(passedLocation.coordinate))
            }
            
            if(!end){
                //Inform user that you are ending the expect me function:
                let sms = "sms: \(passedContact.phoneNumber)&body=I have reached my destination and am ending the Path Deviation function."
                let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                
            }
        }
    }
    
    var body: some View {
        
        NavigationView{
            VStack{
                /*
                Text("Showing progress to \(passedLocation.description)")
                    .font(.headline)
                Text("Sharing location with \(passedContact.name)")
                    .font(.headline)
                Text("Current location: \(manager.center.latitude) \(manager.center.longitude)")
                    .font(.headline)
                    .padding(.horizontal)
                Text("Distance to destination: \(MKMapPoint(manager.center).distance(to: MKMapPoint(passedLocation.coordinate))) meters")
                    .font(.headline)
                    .padding(.horizontal)
                */
                Text("Your selected contact will be notified if you are stopped or headed in the wrong direction.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                PathMapView(passedLocation: passedLocation)
                
                //End expect me function:
                Button(action: {
                    //End expect me?
                    interrupted = true
                }) {
                    HStack{
                        Text("End")
                            .font(.headline)
                    }
                    .padding(9)
                    .foregroundColor(.white)
                    .background(ColorManager.colorPrimary)
                    .cornerRadius(15)
                }
            }
        }
        .navigationTitle("Path Deviation")
        .onAppear(perform: run)
        .alert(isPresented: $interrupted , content: {
            Alert(title: Text("Path Deviation"), message: Text("Would you like to end the Path Deviation function?"),
                  primaryButton: .default(Text("Yes"), action: {
                    end = true
                  }),
                  secondaryButton: .destructive(Text("No")))
        })
    }
}

//struct PathView_Previews: PreviewProvider {
//    static let modelData = ModelData()
//    static let locationData = LocationData()
//    
//    static var previews: some View {
//        PathView(passedContact: modelData.myContacts[0], passedLocation: locationData.myLocations[0])
//            .environmentObject(ModelData())
//            .environmentObject(LocationData())
//    }
//}
