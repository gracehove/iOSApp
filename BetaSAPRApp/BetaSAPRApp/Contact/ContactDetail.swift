//
//  ContactDetail.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI

struct DeleteButton: View {
    @State var passedContact : Contact
    @State var passedList : [Contact]
    @State var delete : Bool = false
    @EnvironmentObject var model: Model
    @Environment(\.presentationMode) var presentationMode
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
                Alert(title: Text("Are you sure?"), message: Text("Would you like to delete this contact?"),
                      primaryButton: .default(Text("Yes"), action: {
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

struct ContactDetail: View {
    @State private var NameVal: String = ""
    @State private var NumberVal: String = ""
    @State var passedContact: Contact
    @State var passedList : [Contact]
    @EnvironmentObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    
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
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("error")
                    }
                    
                }, label: {
                    Text("Update")
                        .foregroundColor(ColorManager.colorPrimary)
                })
                Spacer()
            
                //Delete Contact
                DeleteButton(passedContact:passedContact, passedList: passedList)
                Spacer()
            }
            //Spacer()
                .navigationBarTitleDisplayMode(.inline)
        }//.onAppear{self.model.deleteVisable = true}
    }
}

//struct ContactDetail_Previews: PreviewProvider {
//    static let modelData = ModelData()
//
//    static var previews: some View {
//        ContactDetail(passedContact: modelData.myContacts[0])
//            .environmentObject(modelData)
//            //.previewLayout(.fixed(width: 300, height: 40))
//    }
//}
//
