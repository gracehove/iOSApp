
//  SettingsView.swift
//  Hove_Prototype
//
//  Created by Johnson, Kendall   USN USNA Annapolis on 2/20/21.
//
import MapKit
import SwiftUI
import Foundation
import Contacts
import UIKit

//Location Information
struct Location: Identifiable, Hashable, Codable {

    var id: Int
    var description: String
    var latitude: Double
    var longitude: Double
    var isInactive: Bool
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
   
}

struct Contact: Identifiable, Hashable, Codable {
    var id : Int
    var phoneNumber: String
    var name: String
    var isInactive: Bool
    
}

class Model: ObservableObject {
    @Published var contactVisable = false
    @Published var locationVisable = false
    @Published var deleteVisable = false
    @Published var expectVisable = false
}


func readContacts() -> [Contact] {
    var contacts : [Contact] = []
    if let data = UserDefaults.standard.data(forKey: "contact"){
        do {
            let decoder = JSONDecoder()
            
            contacts = try decoder.decode([Contact].self, from: data)
        } catch {
            print("error")
        }
    }

    return contacts
}

func readLocations() -> [Location] {
    var locations : [Location] = []
    if let data = UserDefaults.standard.data(forKey: "location"){
        do {
            let decoder = JSONDecoder()
            
            locations = try decoder.decode([Location].self, from: data)
        } catch {
            print("error")
        }
    }

    return locations
}

struct SettingsView: View {
    @EnvironmentObject var model: Model
    //@State private var NameVal: String = ""
    //@State private var NumberVal: String = ""
    @State var discrete = false
    @Binding var isOnboardingViewShowing: Bool
    
    let testContact = CNMutableContact()
    let imagage = UIImage(systemName: "person.crop.circle")
    
    //Open settings to change app permissions directly
    private func openSettings(){
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
        if (UIApplication.shared.canOpenURL(settingsURL)){UIApplication.shared.open(settingsURL)}
    }
    
    @State var cons : [Contact] = []
    @State var locs : [Location] = []
    @State var showAdd = false
    var body: some View {
        NavigationView {
            VStack{
                
                //Link to location services settings:
                Button (action: {
                    openSettings()
                }) {
                    HStack{
                        Text("Location Services")
                        Image(systemName: "location.fill")
                    }
                    .padding(7)
                    .foregroundColor(.white)
                    .background(ColorManager.iosBlue)
                    .cornerRadius(15)
                }
                .padding(.top)
                HStack{
                    Toggle("Discrete App logo", isOn: $discrete).onChange(of: discrete) { value in
                        if(discrete){
                            UIApplication.shared.setAlternateIconName("calculator-icon") { error in
                                guard error == nil else {
                                    return
                                }
                            }
                        }
                        else {
                            UIApplication.shared.setAlternateIconName(nil) { error in
                                guard error == nil else {
                                    return
                                }
                            }
                        }
                    }
                }
                .padding(7)
                .foregroundColor(.white)
                .background(ColorManager.iosBlue)
                .cornerRadius(15)
                
                NavigationView{
                    //List of Contacts
                    List(cons) { contact in
                        NavigationLink(destination: ContactDetail(passedContact: contact, passedList: cons)){
                            ContactRow(contact: contact)
                        }
                    }.onAppear{
                        cons = readContacts()
                    }
                    .navigationTitle("Contacts")          //.padding()
                }
                
//                NavigationLink("Add Contact", destination: ContactAdd())
                VStack{
                    Button("Add Contact"){
                        self.model.contactVisable = true
                    }
                    .foregroundColor(ColorManager.colorPrimary)
                    NavigationLink(destination: ContactAdd().environmentObject(model), isActive: $model.contactVisable) {EmptyView()}
                }
                
                NavigationView{
                    //List of Contacts
                    List(locs) { location in
                        NavigationLink(destination: LocationDetail(passedLocation: location, passedList: locs)){
                            LocationRow(location: location)
                        }
                    }.onAppear{
                        locs = readLocations()
                    }
                    //.padding()
                    .navigationTitle("Locations")
                }
                
                NavigationLink("Add Location", destination: LocationAdd())
                    .padding(.bottom)
                    .foregroundColor(ColorManager.colorPrimary)
                    .onAppear{locs = readLocations()}
//                VStack{
//                    Button("Add Location"){
//                        self.model.locationVisable = true
//                    }
//                    .foregroundColor(ColorManager.colorPrimary)
//                    NavigationLink(destination: LocationAdd().environmentObject(model), isActive: $model.locationVisable) {EmptyView()}
//                }
                
            }
            .navigationTitle("Settings")
            .navigationBarItems(trailing: isOnboardingViewShowing ? Button("Done") {
                goHome()
            } : nil )
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    @Binding var isOnboardingViewShowing: Bool
//    static var previews: some View {
//        SettingsView(isOnboardingViewShowing: Binding.constant(true))
//            .environmentObject(LocationData())
//    }
//}


