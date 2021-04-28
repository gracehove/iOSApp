//
//  LoginModel.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/31/21.
//

import SwiftUI
import FirebaseAuth

class LoginModel : ObservableObject {
    @Published var CODE = ""
    
    @Published var code = ""
    
    @Published var phoneNumber = ""
    
    @Published var gotoVerify = false
    
    @Published var showAlert = false
    
    func sendCode(){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (CODE, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            self.CODE = CODE ?? ""
            self.gotoVerify = true
        }
    }

    func verifyCode(){
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: code)
        
        Auth.auth().signIn(with: credential){ (result, err) in
            if let error = err {
                print(error.localizedDescription)
                return
            }
         self.showAlert = true
        }
                           
    }
}
