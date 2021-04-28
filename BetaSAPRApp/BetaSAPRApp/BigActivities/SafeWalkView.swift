//
//  SafeWalkView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI
import UIKit

struct SafeWalkView: View {
    @State var callContact = true
    @State var startingUp = true
    @State var pressed = false
    @State var interrupted = false
    @State var cancled = false
    @Environment(\.presentationMode) var presentationMode
    
    var passedContact: Contact
    var passedLocation: Location
    
    private func countDownToCall(){
        //Start thread timer:
        DispatchQueue.global(qos: .userInteractive).async {
            //user has 10 seconds to cancel
            sleep(10)
            if(!cancled){
                //Call preferred user
                var sms = ""
                
                if(callContact){
                    sms = "tel://\(passedContact.phoneNumber)"
                }
                else { //CHANGE TO 911 LATER ****
                    sms = "tel://411"
                }
                let strURL : String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            } else {print("call cancled")}
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Button(action: {
                    //Do nothing so far
                }) {
                    HStack{
                        Text("Press and HOLD to start safe walk.")
                            .font(.title)
                    }
                    .padding(125)
                    .foregroundColor(ColorManager.iosRed)
                    .background(ColorManager.colorPrimary)
                    .cornerRadius(200)
                    .shadow(color: .black, radius: 3)
                                    .opacity(self.pressed ? 0.5 : 1.0)
                                    .scaleEffect(self.pressed ? 0.8 : 1.0)
                    .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                                    withAnimation(.easeInOut(duration: 0)) {
                                        self.pressed = pressing
                                    }
                                    if pressing {
                                        print("Safe Walk started")
                                        //Do nothing
                                        
                                    } else {
                                        print("Safe Walk ended")
                                        //Initiate alert to cancel
                                        interrupted = true
                                        //Start countdown timer
                                        countDownToCall()
                                    }
                                }, perform: { })
                }
            }
            .alert(isPresented: $interrupted , content: {
                Alert(title: Text("Safe Walk has been interrupted"), message: Text("Click to cancel call"), dismissButton: .destructive(Text("Cancel"), action: {
                    self.cancled = true
                    self.presentationMode.wrappedValue.dismiss()
                }))
            })
        }
        .navigationTitle("Safe Walk")
        .alert(isPresented: $startingUp , content: {
            Alert(title: Text("Safe Walk"), message: Text("Who would you like safe walk to call in case of emergencies?"),
                  primaryButton: .default(Text("911"), action: {
                    startingUp = false
                    callContact = false
                  }),
                  secondaryButton: .default(Text("\(passedContact.name)")))
        })
    }
}

//struct SafeWalkView_Previews: PreviewProvider {
//    static let locationData = LocationData()
//    
//    static var previews: some View {
//        SafeWalkView(passedContact: modelData.myContacts[0], passedLocation: locationData.myLocations[0])
//            .environmentObject(LocationData())
//    }
//}
