//
//  TimeToLeave.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/24/21.
//

import SwiftUI
import Foundation
import Combine

final class TimeToLeaveSettings: ObservableObject {
    @Published var firstTime : Bool {
        didSet {
            UserDefaults.standard.set(firstTime, forKey: "firstTime")
        }
    }
    @Published var fromName : String {
        didSet {
            UserDefaults.standard.set(fromName, forKey: "name")
        }
    }
    
    @Published var message : String {
        didSet {
            UserDefaults.standard.set(message, forKey: "message")
        }
    }
    
    @Published var type : String {
        didSet {
            UserDefaults.standard.set(type, forKey: "type")
        }
    }
    
    init() {
        self.firstTime = UserDefaults.standard.object(forKey: "firstTime") as? Bool ?? true
        self.fromName = UserDefaults.standard.object(forKey: "name") as? String ?? "Jacob Smith"
        self.message = UserDefaults.standard.object(forKey: "message") as? String ?? "You have to get back here right now, you're late for the duty section muster!"
        self.type = UserDefaults.standard.object(forKey: "type") as? String ?? "Text"
    }
}

struct TimeToLeave: View {
    @EnvironmentObject var timeToLeaveSettings : TimeToLeaveSettings
    @State var show = false
    @State var schedule = false
    @State private var name: String = ""
    @State private var message: String = ""
    @State private var isEditing = false
    @State private var currentDate = Date()
    @State private var selectedType = "Text"
    var type = ["Text", "Call"]
    
    private func run(sleepTime: Int){
        //send the user's default communication with appropriate sleep time
        
        DispatchQueue.global(qos: .userInteractive).async {
            //Sleep for the indicated amount of time
            let ms = 1000000
            if sleepTime > 0 {
            usleep(useconds_t(sleepTime*ms))
            //Call function to send!
            sendText()
            }
        }
        
    }
    
    var body: some View {
        ZStack {
            VStack {
                    Image("clouds")
                        .resizable()
                        .scaledToFit()
                
                    Text("SENDER")
                        .font(.title)
                        .foregroundColor(ColorManager.colorPrimary)
                    Text("\(timeToLeaveSettings.fromName)")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(7)
                    //Spacer()
                    Text("MESSAGE")
                        .font(.title)
                        .foregroundColor(ColorManager.colorPrimary)
                    Text("\(timeToLeaveSettings.message)")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(7)
                    //Spacer()
                    Text("TYPE")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(ColorManager.colorPrimary)
                    Text("\(timeToLeaveSettings.type)")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(7)
                    //Spacer()
                    
                //VStack {
                        Button(action: {self.show.toggle()}) {
                            HStack {
                                Image(systemName: "gearshape")
                                    .foregroundColor(ColorManager.iosBlue)
                                Text("Settings")
                                    .foregroundColor(ColorManager.iosBlue)
                            }.padding()
                        }
            
                        Button(action: {timeToLeaveSettings.type == "Text" ? sendText() : sendCall()}
                               , label: {HStack {
                                timeToLeaveSettings.type == "Text" ? Image(systemName: "message") : Image(systemName: "phone")
                                    
                                timeToLeaveSettings.type == "Text" ? Text("Send Text") : Text("Place Call")
                               }})
                            .foregroundColor(ColorManager.iosBlue)
                        
                        Button(action: {self.schedule.toggle()}, label: {
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(ColorManager.iosBlue)
                                Text("Schedule Send")
                                    .foregroundColor(ColorManager.iosBlue)
                            }.padding()
                        })
                    //} .padding()
                }
            .alert(isPresented: $timeToLeaveSettings.firstTime , content: {
                    Alert(
                        title: Text("Would you like to create your own message?"),
                        message: Text("Click Skip if you want a default message."),
                        primaryButton: .default(
                            Text("Customize"),
                            action: {self.show.toggle(); timeToLeaveSettings.firstTime.toggle()}
                        ),
                        secondaryButton: .destructive(
                            Text("Skip"),
                            action: {timeToLeaveSettings.firstTime.toggle()}
                            )
                    )
            })
            .opacity(self.show || self.schedule ? 0 : 1)
            if self.show {
                VStack {
                    VStack{
                        Text("Who do you want your fake communication to come from?")
                        TextField("Name:", text: $name)
                        Text("What should your fake communication say?")
                        TextField("Message:", text: $message)
                        Text("What type of communcation would you like to receive?")
                        Picker("",selection: $selectedType) {
                            ForEach(type, id: \.self){
                                Text($0)
                            }.labelsHidden()
                        }
                        Button(action: {self.show.toggle(); skipInput()}) {
                            Text("Skip")
                                .padding(.top)
                                .foregroundColor(ColorManager.colorPrimary)
                        }
                    } .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height-250, alignment: .center)
                    Button(action: {self.show.toggle(); handleInput()}) {
                        Text("Done")
                            .foregroundColor(ColorManager.colorPrimary)
                    }
                }
            }
            
            if self.schedule {
                VStack {
                    VStack{
                        DatePicker("", selection: $currentDate, displayedComponents: [.hourAndMinute]).labelsHidden()
                        Text("Will send message in \(Int(currentDate.timeIntervalSince(Date()))) seconds with message: \(timeToLeaveSettings.message)")
                    } .frame(width: UIScreen.main.bounds.width-80, height: UIScreen.main.bounds.height-250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Button(action: {self.schedule.toggle(); run(sleepTime: Int(currentDate.timeIntervalSince(Date())))}){
                        Text("Send")
                            .foregroundColor(ColorManager.colorPrimary)
                    }
                }
            }
        }
    }
    
    func handleInput() {
        if name != "" {
            timeToLeaveSettings.fromName = name
            name = ""
        }
        if message != "" {
            timeToLeaveSettings.message = message
            message = ""
        }
        timeToLeaveSettings.type = selectedType
    }
    
    func skipInput() {
        timeToLeaveSettings.fromName = "Jacob Smith"
        timeToLeaveSettings.message = "You have to get back here right now, you're late for the duty section muster!"
        timeToLeaveSettings.type = "Text"
    }
    
    func sendText() {
        let parameters = ["message": "\(timeToLeaveSettings.message)"]
        var url = URLComponents(string: "https://us-central1-usna-sapr-app.cloudfunctions.net/textStatus")!
        url.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: url.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

        }

        task.resume()
    }
    
    func sendCall() {
        let url = URL(string: "https://us-central1-usna-sapr-app.cloudfunctions.net/callUser")!
        var request = URLRequest(url: url)
        
        request.setValue("authToken", forHTTPHeaderField: "Authorization")
        let body = ["":""]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            }
            else if let data = data {
                print(data)
            }
            else {
                
            }
        }
        task.resume()
    }
}

struct TimeToLeave_Previews: PreviewProvider {
    static var previews: some View {
        TimeToLeave().environmentObject(TimeToLeaveSettings())
    }
}
