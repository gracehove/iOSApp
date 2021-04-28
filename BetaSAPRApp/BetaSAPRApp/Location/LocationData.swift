//
//  LocationData.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import Foundation
import Combine
import Contacts

final class LocationData: ObservableObject{
    //Simulation of loading the contacts
    //var contacts = CNMutableContact()
    
    @Published var myLocations: [Location] = [
        Location(id: 1, description: "USNA Gate 1", latitude: 38.978774, longitude: -76.484496, isInactive: false),
        Location(id: 2, description: "Hopper Hall", latitude: 38.985446, longitude: -76.485787, isInactive: false)
    ]
    
}
