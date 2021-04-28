//
//  LocationDetail.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI
import MapKit

struct DeleteButtonLocation: View {
    @Environment(\.presentationMode) var presentationMode
    @State var passedLocation : Location
    @State var passedList : [Location]
    @State var delete : Bool = false
    var body: some View {
        Button(action: {
           delete = true
        }) {
            HStack{
                Text("Delete")
                Image(systemName: "trash")
            }
            .padding(7)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(15)
            .alert(isPresented: $delete, content: {
                Alert(title: Text("Are you sure?"), message: Text("Would you like to delete this location?"),
                      primaryButton: .default(Text("Yes"), action: {
                        do {
                            let encoder = JSONEncoder()
                            passedList.remove(at: passedLocation.id)
                            for (index, contact) in passedList.enumerated() {
                                print(index)
                                if(passedLocation.id < contact.id) {
                                    passedList[index].id = contact.id - 1
                                }
                                    
                            }
                            let data = try encoder.encode(passedList)
                            UserDefaults.standard.set(data, forKey: "location")
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("error")
                        }
                                  }),
                                  secondaryButton: .destructive(Text("No")))
            })
        }
    }
}


struct LocationDetail: View {
    @StateObject private var manager = LocationManager()
//    @EnvironmentObject var locationData: LocationData
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.978774, longitude: -76.484496),
        span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
    
    private func updateMap(){
        //Update the coordinate region to be displayed.
        self.region = MKCoordinateRegion(
            center: passedLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004))
            
    }
    
    @State var passedLocation: Location
    @State var passedList: [Location]
    
//    var locationIndex: Int {
//        locationData.myLocations.firstIndex(where: { $0.id == passedLocation.id })!
//    }
//
    var body: some View {
        
        //ADD A MARKER AND TRY TO RECENTER
        VStack(alignment: .leading){
            
            //Add a map pin for all the saved locations!
            Map(coordinateRegion: $region, annotationItems: passedList){
                MapPin(coordinate: $0.coordinate)
            }
                .frame(height: 150)
            
            HStack{
                Text(passedLocation.description)
                    .font(.headline)
                    .padding(.leading)
                Spacer()
                DeleteButtonLocation(passedLocation: passedLocation, passedList: passedList)
                    .padding(.trailing)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: updateMap) //Need the region to contain preferred location
        }
    }
}

//struct LocationDetail_Previews: PreviewProvider {
//    static let locationData = LocationData()
//
//    static var previews: some View {
//        LocationDetail(passedLocation: locationData.myLocations[0])
//            .environmentObject(locationData)
//    }
//}
