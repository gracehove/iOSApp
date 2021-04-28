//
//  FindMeARideView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/24/21.
//
import SwiftUI
import MapKit

struct FindMeARideView: View {
    @ObservedObject private var locationManager = LocationManager()
    @State var cons : [Contact] = []

    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                    .frame(height: 350)
                
                Spacer()
                if(cons.count > 0){
                    NavigationLink(destination: ContactListMsg(contactsToCall: cons)){
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(ColorManager.iosBlue)
                            Text("Share my Location")
                                .foregroundColor(ColorManager.colorPrimary)
                        }
                    }
                    
                    Spacer()
                    NavigationLink(destination: ContactList(contactsToCall: cons)) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(ColorManager.iosBlue)
                            Text("Call my Friends")
                                .foregroundColor(ColorManager.colorPrimary)
                        }
                    }
                }
                Spacer()
                //Send manual update
                Button(action: {
                    print("Location Shared")
                    call(phoneNumber: "tel://4103205961")
                }) {
                    HStack{
                        Image(systemName: "car.fill")
                            .foregroundColor(ColorManager.iosBlue)
                        Text("Call Shipmate")
                            .foregroundColor(ColorManager.colorPrimary)
                    }
                }
                /*
                Button("Call Shipmate"){
                    print("Location Shared")
                    call(phoneNumber: "tel://4103205961")
                }*/
                
                Spacer()
                Button(action: {
                    print("calling")
                    call(phoneNumber: "tel://4439950022")
                }) {
                    HStack{
                        Image(systemName: "phone.fill")
                            .foregroundColor(ColorManager.iosBlue)
                        Text("Call a Taxi")
                            .foregroundColor(ColorManager.colorPrimary)
                    }
                }
                /*
                Button("Call a Taxi"){
                    print("Location Shared")
                    call(phoneNumber: "tel://4439950022")
                }*/
                Spacer()
//                Button(action: {goUber()}, label: {
//                    Text("Open Uber")
//                })
            }
        }
        .navigationTitle("Find Me A Ride")
        .onAppear {
            cons = readContacts()
        }
    }
}

//func goUber(){
//    guard let uberURL = URL(string: "https://m.uber.com/ul/?client_id=<CLIENT_ID>") else {return}
//    if (UIApplication.shared.canOpenURL(uberURL)){UIApplication.shared.open(uberURL)}
//}

func call(phoneNumber: String) -> Void{
    print ("Calling", phoneNumber)
    guard let url = URL(string: phoneNumber) else {return}
    UIApplication.shared.open(url)
}

//struct FindMeARideView_Previews: PreviewProvider {
//    static var previews: some View {
//        FindMeARideView()
//            .environmentObject(ModelData())
//    }
//}
