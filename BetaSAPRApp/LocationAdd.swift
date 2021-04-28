//
//  LocationAdd.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//
import SwiftUI
import MapKit

struct LocationView: UIViewRepresentable {
    @State var centerCoordinate = CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496)

    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
    
        //let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
        let region = MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    
    
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
    //print(#function)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: LocationView

        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: LocationView) {
            self.parent = parent
            super.init()
            self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.gRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }

        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
            
            // position on the screen, CGPoint
            let location = gRecognizer.location(in: self.parent.mapView)
            // position on the map, CLLocationCoordinate2D
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
            
            self.parent.centerCoordinate = coordinate
            print(coordinate)
            
            //Add the new location!
            let p1 = MKPlacemark(coordinate: coordinate)
            
            self.parent.mapView.addAnnotation(p1)
            
        }
    }
}



struct LocationAdd: View {
//    @EnvironmentObject var locationData: LocationData
    @State var locationView = LocationView()
    @State private var name: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Image(systemName: "globe")
                    .foregroundColor(ColorManager.iosBlue)
                    .frame(width: 36.0, height: 39.0)
                Spacer()
            }
            Text("Location Description:")
                .font(.largeTitle)
            TextField("USNA Gate 1", text: $name)
                .padding(.leading)
            
            locationView
            
            Text("Click on map to add remembered location")
            
            HStack{
                Spacer()
                Button(action: {
                    //Update
//                    if(name != "" && (locationView.mapView.centerCoordinate.latitude) != 38.978774) {
//                        let newLocation: Location = Location(id: (locationData.myLocations.count + 1), description: name, latitude: locationView.mapView.centerCoordinate.latitude, longitude: locationView.mapView.centerCoordinate.longitude, isInactive: false)
//
//                        locationData.myLocations.append(newLocation)
                    
                if(name != "" && (locationView.mapView.centerCoordinate.latitude) != 38.978774) {
                    if let data = UserDefaults.standard.data(forKey: "location") {
                        do {
                            let decoder = JSONDecoder()
                            
                            var locations = try decoder.decode([Location].self, from: data)
                            let newLocation = Location(id: (locations.count), description: name, latitude: locationView.mapView.centerCoordinate.latitude, longitude: locationView.mapView.centerCoordinate.longitude, isInactive: false)
                            locations.append(newLocation)
                            do {
                                let encoder = JSONEncoder()
                                
                                let data = try encoder.encode(locations)
                                UserDefaults.standard.set(data, forKey: "location")
                                self.presentationMode.wrappedValue.dismiss()
                            } catch {
                                print("error")
                            }
                        } catch {
                            print("decode error")
                        }
                    }
                    else {
                        do {
                            let encoder = JSONEncoder()
                            let newLocation = Location(id: 0, description: name, latitude: locationView.mapView.centerCoordinate.latitude, longitude: locationView.mapView.centerCoordinate.longitude, isInactive: false)
                            let locations = [newLocation]

                            let data = try encoder.encode(locations)
                            UserDefaults.standard.set(data, forKey: "location")
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("error")
                        }
                      }
                    
                    }
                }, label: {
                    HStack{
                        Text("Add")
                    }
                    .padding(7)
                    .foregroundColor(.white)
                    .background(ColorManager.colorPrimary)
                    .cornerRadius(15)
                })
                Spacer()
            }
            .padding(.top)
            
        }
        .padding(.trailing)
    }
}

struct LocationAdd_Previews: PreviewProvider {
    static var previews: some View {
        LocationAdd()
    }
}

