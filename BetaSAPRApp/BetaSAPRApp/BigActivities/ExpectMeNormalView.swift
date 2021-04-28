//
//  ExpectMeNormalView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI
import UIKit
import MapKit


/** DEFINES BIG MAP!!! */

struct ExpectMeMapView: UIViewRepresentable {
    @State var centerCoordinate = CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496)
    
    var passedLocation : Location
    var passedContact: Contact
    var userPhone : String
    var end : Bool
    
    let mapView = MKMapView()

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
    
        //let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
        let region = MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        //Add a marker to where we're going:
        let p1 = MKPlacemark(coordinate: passedLocation.coordinate)
        mapView.addAnnotation(p1)
    
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if(!end){
            friend.newUser(username: userPhone, friend: passedContact.phoneNumber, lat: view.userLocation.coordinate.latitude, long: view.userLocation.coordinate.longitude)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: ExpectMeMapView

        var gRecognizer = UITapGestureRecognizer()

        init(_ parent: ExpectMeMapView) {
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


/** REGULAR EXPECT ME VIEW */

struct ExpectMeNormalView: View {
    @EnvironmentObject var userInfo : UserInfo
    @EnvironmentObject var model : Model
    @StateObject private var manager = LocationManager()
    @State var interrupted : Bool = false
    @State var end : Bool = false
    @State var update : String = ""
    var passedContact: Contact
    var passedLocation: Location
    var userPhone : String
    
    private func run(){
        //Run on background thread
        DispatchQueue.global(qos: .userInteractive).async {
            sleep (1) //gimmie a second to catch up!
            //Inform user that you are starting the expect me function:
            var sms = ""
            if(manager.center.latitude == 0.0 && manager.center.longitude == 0.0){
                sms = "sms: \(passedContact.phoneNumber)&body=I'm walking back to \(passedLocation.description) with the Expect Me function. I will text you updates along the way."
            }
            else{
            sms = "sms: \(passedContact.phoneNumber)&body=I'm walking back to \(passedLocation.description) with the Expect Me function. Follow along with me in your SAPR App under \"My Friends\""
            }
            let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            friend.newUser(username: userPhone, friend: passedContact.phoneNumber, lat: passedLocation.latitude, long: passedLocation.longitude)
            
            while(MKMapPoint(manager.center).distance(to: MKMapPoint(passedLocation.coordinate)) > 30){
                if(end){
                    //Inform user that you are ending the expect me function:
                    let sms = "sms: \(passedContact.phoneNumber)&body=I have ended the Expect Me function."
                    let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                    break
                }
            }
            
            if(!end){
                //Inform user that you are ending the expect me function:
                let sms = "sms: \(passedContact.phoneNumber)&body=I have reached my destination and am ending the Expect Me function."
                let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                
            }
            
        }
        
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Your selected contact will be able to see your progress.")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
                /*Text("Showing progress to \(passedLocation.description)")
                    .font(.headline)
                    .padding(.horizontal)
                Text("Sharing location with \(passedContact.name)")
                    .font(.headline)
                    .padding(.horizontal)
                */
                
                Spacer()
                
                /*Text("Current location: \(manager.center.latitude) \(manager.center.longitude)")
                    .font(.headline)
                    .padding(.horizontal)
                Text("Distance to destination: \(MKMapPoint(manager.center).distance(to: MKMapPoint(passedLocation.coordinate))) meters")
                    .font(.headline)
                    .padding(.horizontal)*/
                
                ExpectMeMapView(passedLocation: passedLocation, passedContact: passedContact, userPhone: userPhone, end: end)
                
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
                    .background(ColorManager.iosBlue)
                    .cornerRadius(15)
                }
                HStack{
                    Text("Manual Update")
                        .padding(.leading)
                        .font(.body)
                        .foregroundColor(ColorManager.colorPrimary)
                    
                    Spacer()
                }
                HStack{
                    //User enters manual update
                    TextField("Written location description: ", text: $update)
                        .padding(.leading)
                    
                    //Send manual update
                    Button(action: {
                        let sms = "sms: \(passedContact.phoneNumber)&body=\(update)"
                        let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                    }) {
                        HStack{
                            Text("Update")
                            Image(systemName: "message.fill")
                        }
                        .padding(7)
                        .foregroundColor(.white)
                        .background(ColorManager.colorPrimary)
                        .cornerRadius(15)
                    }
                }
                    
            }
            
        }
        .padding(.bottom)
        .navigationTitle("Expect Me")
        .onAppear(perform: run)
        .alert(isPresented: $interrupted , content: {
            Alert(title: Text("Expect Me"), message: Text("Would you like to end the Expect Me function?"),
                  primaryButton: .default(Text("Yes"), action: {
                    end = true
                    friend.removeUser(username: userPhone)
                    self.model.expectVisable = false
                  }),
                  secondaryButton: .destructive(Text("No")))
        })
    }
}

//struct ExpectMeNormalView_Previews: PreviewProvider {
//    static let locationData = LocationData()
//    
//    static var previews: some View {
//        ExpectMeNormalView(passedContact: modelData.myContacts[0], passedLocation: locationData.myLocations[0], userPhone: "")
//            .environmentObject(LocationData())
//            .environmentObject(UserInfo())
//    }
//}
