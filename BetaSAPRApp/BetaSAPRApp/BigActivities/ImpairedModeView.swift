//
//  ImpairedModeView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/24/21.
//

import SwiftUI
import MapKit

struct ContactList: View {
    var contactsToCall: [Contact]
    var body: some View {
        NavigationView {
            List(contactsToCall) {
                contact in ListRow(eachContact: contact, allContact: contactsToCall)
            }.navigationBarTitle(Text("Friends"))
        }
    }
}

struct ContactListMsg: View {
    var contactsToCall: [Contact]
    var body: some View {
        NavigationView {
            List(contactsToCall) {
                contact in ListRowMsg(eachContact: contact, allContact: contactsToCall)
            }.navigationBarTitle(Text("Friends"))
        }
    }
}

struct ListRow: View {
    @State private var timeRemaining = 7
    @State private var isActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var eachContact: Contact
    var allContact: [Contact]
    var body: some View {
        HStack {
            Text(eachContact.name)
            Spacer()
            Button(action: {
                let telephone = "tel://"
                let formattedString = telephone + eachContact.phoneNumber
                guard let url = URL(string: formattedString) else {return}
                UIApplication.shared.open(url)
            }) {
                Text(eachContact.phoneNumber)
            }
        } .onReceive(timer, perform: { _ in
            guard self.isActive else {return}
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else if self.timeRemaining == 0 {
                self.timer.upstream.connect().cancel()
                let firstContactPhone = allContact[0].phoneNumber
                let formattedString = "tel://" + firstContactPhone
                guard let url = URL(string: formattedString) else {return}
                UIApplication.shared.open(url)
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.isActive = true
        }
    }
}

struct ListRowMsg: View {
    @ObservedObject private var locationManager = LocationManager()
    @State private var timeRemaining = 7
    @State private var isActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var eachContact: Contact
    var allContact : [Contact]
    var body: some View {
        let coordinate = self.locationManager.center
        HStack {
            Text(eachContact.name)
            Spacer()
            Button(action: {
                self.timer.upstream.connect().cancel()
//                let sms: String = "sms:\(eachContact.phoneNumber)&body=I'm impaired: Here is my location \(coordinate.latitude) \(coordinate.longitude)"
                //let sms: String = "sms:\(eachContact.phoneNumber)&body=I'm at "
                let sms: String = "sms:\(eachContact.phoneNumber)&body=I am sending you my current location through the USNA SAPR App: http://www.google.com/maps/place/\(coordinate.latitude),\(coordinate.longitude)"
                let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            }) {
                Text(eachContact.phoneNumber)
            }
        } .onReceive(timer, perform: { _ in
            guard self.isActive else {return}
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else if self.timeRemaining == 0 {
                self.timer.upstream.connect().cancel()
                let firstContactPhone = allContact[0].phoneNumber
//                let sms = "sms: \(firstContactPhone)&body=I'm impaired: Here is my location \(coordinate.latitude) \(coordinate.longitude)"
                let sms: String = "sms:\(firstContactPhone)&body=I am sending you my current location through USNA SAPR App: http://www.google.com/maps/place/\(coordinate.latitude),\(coordinate.longitude)"
                let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.isActive = true
        }
    }
}

struct ImpairedModeView: View {
    //var numSavedCont = myContacts.count
    @State var showSafeWalk = false
    @State var showDetails = false
    @State var showAlertSafe = false
    
    @State var cons : [Contact] = []
    var body: some View {
        
        NavigationView{
            VStack{
                VStack{
                    if cons.count > 0 {
                        NavigationLink(destination: ContactList(contactsToCall: cons)) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Call my Friends")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                            .padding(50)
                            .foregroundColor(.white)
                            .background(ColorManager.colorPrimaryDark)
                            .cornerRadius(40)
                        }
                        .padding(15)
                        
                        NavigationLink(destination: ContactListMsg(contactsToCall: cons)){
                            HStack {
                                Image(systemName: "location.fill")
                                Text("Share my Location")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                            .padding(45)
                            .foregroundColor(.white)
                            .background(ColorManager.iosBlue)
                            .cornerRadius(40)
                        }
                        .padding(15)
                    }
                    Button(action: {
                        self.showDetails.toggle()
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call the Police")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        .padding(50)
                        .foregroundColor(.white)
                        .background(ColorManager.colorPrimary)
                        .cornerRadius(40)
                    }
                    .padding(15)
                }
                .alert(isPresented: $showDetails) { () -> Alert in
                    let primaryButton = Alert.Button.default(Text("OK")) {
                        let formattedString = "tel://123456789" //CHANGE TO 911 AFTER DEMO PHASE
                        guard let url = URL(string: formattedString) else {return}
                        UIApplication.shared.open(url)
                    }
                    let secondaryButton = Alert.Button.cancel(Text("Cancel")) {}
                    return Alert(title: Text("Call the Police"), message: Text("Pressing OK will call 911"), primaryButton: primaryButton, secondaryButton: secondaryButton)
                }
            }
            .navigationTitle("Impaired Mode")
        }.onAppear{
            cons = readContacts()
        }
    }
}


//struct ImpairedModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImpairedModeView()
//            .environmentObject(ModelData())
//            .environmentObject(LocationData())
//    }
//}
