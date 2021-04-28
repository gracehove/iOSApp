//
//  LocationServer.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/25/21.
//

import FirebaseDatabase

final class Update: ObservableObject {
    let ref: DatabaseReference! = Database.database().reference(withPath: "Users")
    func removeUser(username: String){
        self.ref
            .child(username).removeValue()
    }
    
    func newUser(username: String, friend: String, lat: Double, long: Double){
        self.ref.child(username).child("Contact").setValue(friend)
        self.ref.child(username).child("Location").child("Lat").setValue(lat)
        self.ref.child(username).child("Location").child("Long").setValue(long)
    }
    
    func getLatData(username:String) -> Double{
        var lat = 0.0
        self.ref.child(username).child("Location").child("Lat").getData { (error, snapshot) in
            if let error = error {
                print(error)
            }
            else if snapshot.exists() {
                lat = snapshot.value as! Double
                print(lat)
            }
            else {
                lat = 91.0
            }
        }
        let count = 1...1000
        for _ in count {
            usleep(1000)
            if lat != 0.0 || lat == 91.0{
                break
            }
        }
        return lat
    }
    
    func getLongData(username:String) -> Double{
        var long = 0.0
        self.ref.child(username).child("Location").child("Long").getData { (error, snapshot) in
            if let error = error {
                print(error)
            }
            else if snapshot.exists() {
                long = snapshot.value as! Double
                print(long)
            }
            else {
                long = 181.0
            }
        }
        let count = 1...1000
        for _ in count {
            usleep(1000)
            if long != 0.0 || long == 181.0{
                break
            }
        }
        return long
    }
}
