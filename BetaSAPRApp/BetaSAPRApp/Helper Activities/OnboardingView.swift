//
//  OnboardingView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/24/21.
//

import SwiftUI
import FirebaseAuth

final class UserInfo: ObservableObject {
    @Published var userName : String {
        didSet {
            UserDefaults.standard.set(userName, forKey: "username")
            }
        }
    @Published var userNumber : String {
        didSet {
            UserDefaults.standard.set(userNumber, forKey: "phone")
        }
    }
    
    init() {
        self.userName = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        self.userNumber = UserDefaults.standard.object(forKey: "phone") as? String ?? ""
    }
    
}

struct OnboardingView: View {
    @Binding var isOnboardingViewShowing: Bool
    @State private var nameText: String = ""
    @State private var phoneNumer: String = ""
    @State private var googleAuth: String = ""
    @State private var setInfo : Bool = false
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var login = LoginModel()
    
    var body: some View {
        VStack {
            Text("Welcome")
                .font(.title)
                .padding()
            Text("Please enter in your Information:")
                .padding()
            
            TextField("Your Name",text: $nameText)
                .frame(width: 300, height: 65)
            TextField("(123)456-7890",text: $phoneNumer)
                .frame(width: 300, height: 65)
                .keyboardType(.namePhonePad)
            Button(action: {setUserInfo()}, label: {
                Text("Confirm")
            })
            if(login.gotoVerify) {
                TextField("123456",text: $googleAuth)
                    .frame(width: 300, height: 65)
                Button(action: {login.code = googleAuth; login.verifyCode(); if(login.showAlert){self.setInfo.toggle()}}, label: {
                  Text("Verify")
                })
            }
        } .textFieldStyle(RoundedBorderTextFieldStyle())
          .sheet(isPresented: $setInfo){
            VStack{
                Text("Would you like to customize settings?")
                HStack {
                    Button(action: {isOnboardingViewShowing.toggle()}, label: {
                    Text("No")
                        .foregroundColor(.red)
                }).padding()
                Button(action: {isOnboardingViewShowing.toggle(); goSettings()}, label: {
                    Text("Yes")
                }).padding()
            }
          }
        }
    }
    func setUserInfo() {
        if phoneNumer != "" {
            userInfo.userNumber = phoneNumer
            login.phoneNumber = "+1\(phoneNumer)"
            login.sendCode()
        }
    }
}


func goSettings() {
    if let window = UIApplication.shared.windows.first{
        window.rootViewController = UIHostingController(rootView: SettingsView(isOnboardingViewShowing: Binding.constant(true)).environmentObject(Model()))
        window.makeKeyAndVisible()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboardingViewShowing: Binding.constant(true)).environmentObject(UserInfo())
    }
}
