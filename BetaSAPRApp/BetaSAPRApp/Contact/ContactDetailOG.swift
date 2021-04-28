//  ContactDetail.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI

struct DeleteButtonOG: View {
    @State var passedContact : Contact
    @State var passedList : [Contact]
    @EnvironmentObject var model: Model
    var body: some View {
        Button(action: {
            do {
                let encoder = JSONEncoder()
                passedList.remove(at: passedContact.id)
                for (index, contact) in passedList.enumerated() {
                    print(index)
                    if(passedContact.id < contact.id) {
                        passedList[index].id = contact.id - 1
                    }
                        
                }
                let data = try encoder.encode(passedList)
                UserDefaults.standard.set(data, forKey: "contact")
                self.model.deleteVisable = false
            } catch {
                print("error")
            }
        }) {
            HStack{
                Text("Delete")
                Image(systemName: "trash")
            }
            .padding(7)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(15)
        }
    }
}

struct ContactDetailOG: View {
    @State private var NameVal: String = ""
    @State private var NumberVal: String = ""
    @State var passedContact: Contact
    @State var passedList : [Contact]
    @EnvironmentObject var model: Model
    
//    var contactIndex: Int {
//        modelData.myContacts.firstIndex(where: { $0.id == passedContact.id })!
//    }
    
    var body: some View {
        
       
        VStack{
            HStack{
                //Contact Name
                Spacer()
                Text("Name:")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                TextField(passedContact.name, text: $NameVal)
                    .padding(.leading)
                
            }
            .padding()
            HStack {
                Text("Phone Number:")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
                TextField(passedContact.phoneNumber, text: $NumberVal)
                    .padding(.leading)
                
            }
            .padding()
            
            HStack{
                Spacer()
            
                //Update Contact
                Button(action: {
                    //Update
                    if (NameVal != "") {
                        //modelData.myContacts[contactIndex].name = NameVal
                        passedContact.name = NameVal
                        
                    }
                    if (NumberVal != "") {
                        passedContact.phoneNumber = NumberVal
                        
                        //modelData.myContacts[contactIndex].phoneNumber = NumberVal
                    }
                    
                    do {
                        let encoder = JSONEncoder()
                        passedList[passedContact.id] = passedContact
                        let data = try encoder.encode(passedList)
                        UserDefaults.standard.set(data, forKey: "contact")
                        self.model.deleteVisable = false
                    } catch {
                        print("error")
                    }
                    
                }, label: {
                    Text("Update")
                        .foregroundColor(ColorManager.colorPrimary)
                })
                Spacer()
            
                //Delete Contact
                DeleteButton(passedContact: passedContact, passedList: passedList)
                Spacer()
            }
            //Spacer()
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

