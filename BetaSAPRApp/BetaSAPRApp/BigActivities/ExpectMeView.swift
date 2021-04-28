//
//  ExpectMeView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//
import SwiftUI
import MapKit
import UIKit

struct ExpectMeView: View {
    //@ObservedObject private var locationManager = LocationManager()
    @EnvironmentObject var userInfo : UserInfo
    @EnvironmentObject var model: Model
    //@State private var safeWalkToggleState: Bool = false
    //@State private var pathDeviationToggleState: Bool = false
    @State private var newLocationName: String = ""
    @State private var newContactNumber: String = ""
    @StateObject private var manager = LocationManager()
    @State private var didTapLocation: Bool = false
    @State private var didTapContact: Bool = false
    @State var cons : [Contact] = []
    @State var locs : [Location] = []
    @State private var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @State var clickedContact : Contact = Contact(id: 1, phoneNumber: "7016210161", name: "Grace", isInactive: false)
    @State var clickedLocation : Location = Location(id: 1, description: "USNA Gate 1", latitude: 46.612199, longitude: -112.035118, isInactive: false)
    
    //Try to update to current location?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496),
        span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
    
    var body: some View {
        //let coordinate = self.locationManager.location != nil ? self.locationManager.location!.coordinate: CLLocationCoordinate2D()
        
        //NavigationView{
        ScrollView{
            VStack{
                
                Text("Please select an intended destination and contact.")
                    .foregroundColor(.gray)
                    .font(.footnote)
            
                HStack{
                    Text("Destinations")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .foregroundColor(ColorManager.colorPrimary)
                    Spacer()
                }
                
                /*Text("Where are you going?")
                    .font(.headline)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)*/
                
                //List location options *ADD ON CLICK LISTENER
                ScrollView {
                    
                    List(locs){ location in
                        LocationRow(location: location)
                            .onTapGesture{
                                newLocationName = location.description
                                self.didTapLocation = true
                                self.clickedLocation = location
                                print("clicked \(location.description)")
                            }
                    }
                    .frame(height: 100.0)
                    HStack{
                        Text("Other: ")
                            .padding(.leading)
                            .foregroundColor(ColorManager.colorPrimaryDark)
                        TextField("Location Name", text: $newLocationName)
                        Button(action: {
                            print("OK")
                            self.didTapLocation = true
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                    
                            }
                            //.frame(minWidth: 0, maxWidth: .infinity)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(didTapLocation ? ColorManager.iosGreen : Color.gray)
                            .cornerRadius(15)
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.vertical)
                
                HStack{
                    Text("Contacts")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .foregroundColor(ColorManager.colorPrimary)
                    Spacer()
                }
                
                /*Text("Who would you like to send your progress to?")
                    .font(.headline)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
                */
                //Contact Options List * ADD ON CLICK LISTENER
                ScrollView{
                    List(cons){ contact in
                        ContactRow(contact: contact)
                            .onTapGesture{
                                newContactNumber = contact.name
                                self.didTapContact = true
                                self.clickedContact = contact
                                print("clicked \(contact.name)")
                            }
                    }
                    .frame(height: 100.0)
                    HStack{
                        Text("Other: ")
                            .padding(.leading)
                            .foregroundColor(ColorManager.colorPrimaryDark)
                        TextField("Phone Number", text: $newContactNumber)
                        Button(action: {
                            print("OK")
                            self.didTapContact = true
                            
                        }) {
                            HStack {
                                Image(systemName: "person")
                            }
                            //.frame(minWidth: 0, maxWidth: .infinity)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(didTapContact ? ColorManager.iosGreen : Color.gray)
                            .cornerRadius(15)
                        }
                        .padding(.trailing)
                    }
                }
                .padding(.vertical)
                
                HStack{
                    Text("Location")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .foregroundColor(ColorManager.colorPrimary)
                    Spacer()
                }
                
                VStack{
                /*Text("Current Location: \(manager.center.latitude) \(manager.center.longitude)")
                    .font(.headline)
                    .foregroundColor(.gray)
                */
                //Probably going to replace this with a map
                
                    Map(coordinateRegion: $manager.region, showsUserLocation: true)
                        .frame(height: 175)
                    /*Map(coordinateRegion: $region)
                    .frame(height: 175)
                */
                    //Going to need to update with real clicked choices
                    NavigationLink(destination: ExpectMeNormalView(passedContact: clickedContact, passedLocation: clickedLocation, userPhone: userInfo.userNumber).environmentObject(model), isActive: $model.expectVisable){
                        Text(" START route to \(newLocationName)")
                            .padding()
                            .foregroundColor(.white)
                            .background(ColorManager.iosBlue)
                            .cornerRadius(40)
                    }
                    
                    Spacer()
                    
                    Text("Utilize other functions:")
                        .padding(.top)
                        .font(.headline)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
                    
                    HStack{
                        NavigationLink(destination: SafeWalkView(passedContact: clickedContact, passedLocation: clickedLocation)){
                            Text("SAFE WALK")
                                .padding()
                                .foregroundColor(.white)
                                .background(ColorManager.colorPrimary)
                                .cornerRadius(40)
                        }
                        .padding(.horizontal)
                    
                        Spacer()
                        
                        NavigationLink(destination: PathView(passedContact: clickedContact, passedLocation: clickedLocation)){
                            Text("PATH DEVIATION")
                                .padding()
                                .foregroundColor(.white)
                                .background(ColorManager.colorPrimary)
                                .cornerRadius(40)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            //Top Title
            .navigationTitle("Expect Me")
            .onAppear{
                cons = readContacts()
                locs = readLocations()
            }
        }
    }
}

////Should automatically import all location and contact information.
//struct ExpectMeView_Previews: PreviewProvider {
//    //static var modelData = ModelData()
//    //static var locationData = LocationData()
//    //@EnvironmentObject var modelData: ModelData
//    static var previews: some View {
//        ExpectMeView()
//            .environmentObject(ModelData())
//            .environmentObject(LocationData())
//            .environmentObject(UserInfo())
//    }
//}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    @Published var center = CLLocationCoordinate2D()
    private let locationManager = CLLocationManager()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locations.last.map {
            center = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
            region = MKCoordinateRegion(center: center, span: span)
        }
    }
}
