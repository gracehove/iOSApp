//
//  EditContactView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI


struct EditContactView: View {
    
    
    
    var test: String = ""
    
    @State private var contactName: String = ""
    @State private var contactNumber: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Spacer()
                
                Text("Contact Name")
                    .font(.largeTitle)
                
                Text("Phone Number")
                    .font(.largeTitle)
                TextField("(123) 456-7890:", text: $contactNumber)
                    .padding(.leading)
                Spacer()
                
                NavigationLink(
                    destination: SettingsView(isOnboardingViewShowing: Binding.constant(false)),
                    label: {
                        Text("Add Contact")
                    })
                    
                
            
            }
            .foregroundColor(.blue)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct EditContactView_Previews: PreviewProvider {
    static var previews: some View {
        EditContactView()
    }
}

