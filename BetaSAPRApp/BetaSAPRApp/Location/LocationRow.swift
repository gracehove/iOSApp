//
//  LocationRow.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//


import SwiftUI

struct LocationRow: View {
    var location: Location
    
    var body: some View {
        HStack {
            Text(location.description)
            Spacer()
            Image(systemName: "globe")
                .foregroundColor(ColorManager.iosBlue)
        }
    }
}

//struct LocationRow_Previews: PreviewProvider {
//    static var myLocations = LocationData().myLocations
//    
//    static var previews: some View {
//        LocationRow(location: myLocations[1])
//            .previewLayout(.fixed(width: 300, height: 40))
//    }
//}
