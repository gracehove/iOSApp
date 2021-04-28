//
//  ContentView.swift
//  BetaSAPRApp
//
//  Created by Alex Hernandez on 3/23/21.
//

import SwiftUI

struct ColorManager {
    // create static variables for custom colors
    static let colorAccent = Color("colorAccent")
    static let colorPrimary = Color("colorPrimary")
    static let colorPrimaryDark = Color("colorPrimaryDark")
    static let iosBlue = Color("iosBlue")
    static let iosGreen = Color("iosGreen")
    static let iosOrange = Color("iosOrange")
    static let iosRed = Color("iosRed")
    //... add the rest of your colors here
}

struct ContentView: View {
    @AppStorage("OnBoardingView") var isOnboardingViewShowing = true
    @State var cons : [Contact] = []
    var body: some View {
        if isOnboardingViewShowing {
            OnboardingView(isOnboardingViewShowing: $isOnboardingViewShowing).environmentObject(UserInfo())
        } else {
            TabView {
                HomeView()
                    .environmentObject(Model())
                    .tabItem {
                        Image(systemName: "house")
                        Text("HOME")
                    }
                SettingsView(isOnboardingViewShowing: $isOnboardingViewShowing).environmentObject(Model())
                    .tabItem {
                        Image(systemName: "gear")
                        Text("SETTINGS")
                    }
                ImpairedModeView()
                    .tabItem{
                        Image(systemName: "eye.slash")
                        Text("IMPAIRED MODE")
                    }
                MyFriendsView(cons: cons)
                    .tabItem{
                        Image(systemName: "person.crop.circle")
                        Text("MY FRIENDS")
                    }.onAppear{
                        cons = readContacts()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView: View {
    @State var showImpairedMode = false
    @State var showSafeWalk = false
    @State var showDetails = false
    @State var showAlertSafe = false
    @State var isContactMoreThanOne = false
    @State var cons : [Contact] = []
    @EnvironmentObject var model: Model
    //@EnvironmentObject var modelData : ModelData
    var body: some View {
        NavigationView {
            VStack {

                //Spacer()
                //Expect Me
                if(cons.isEmpty){
                    Image("tcourt")
                        .resizable()
                        .scaledToFit()
                    Button(action:{isContactMoreThanOne.toggle()}){
                        VStack{
                            Text("Expect Me")
                                .font(.largeTitle)
                                .foregroundColor(ColorManager.colorPrimary)
                            Text("Send location to a friend so they can follow along with you.")
                                .foregroundColor(.gray)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        
                    }.alert(isPresented: $isContactMoreThanOne, content: {
                        Alert(
                            title: Text("Please add at least one contact"),
                            message: Text(""),
                            primaryButton: .default(
                                Text("Settings"),
                            action: {goSettings()}
                            ),
                            secondaryButton: .destructive(
                                Text("Skip"),
                                action:{}
                            )
                        )
                    })
                }
                else{
                    Image("tcourt")
                        .resizable()
                        .scaledToFit()
                    
                    //Spacer()
                    
                    NavigationLink("Expect Me", destination:
                                ExpectMeView()
                                .environmentObject(UserInfo())
                                .environmentObject(Model()))
                        //.foregroundColor("colorPrimary")
                        .font(.largeTitle)
                        .foregroundColor(ColorManager.colorPrimary)
                    Text("Send location to a friend so they can follow along with you.")
                        .foregroundColor(.gray)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                //Find Me A Ride
                NavigationLink("Find Me a Ride", destination: FindMeARideView())//.environmentObject(ModelData()))
                    .font(.largeTitle)
                    .foregroundColor(ColorManager.colorPrimary)
                
                Text("Call Shipmate or share location with a friend.")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                //Time to Leave
                NavigationLink("Time to Leave", destination: TimeToLeave())
                    .font(.largeTitle)
                    .foregroundColor(ColorManager.colorPrimary)
                
                Text("Send yourself an alert to get out of an uncomfortable situation.")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                //SAPR Information Center
                Link("SAPR Resource Center", destination: URL(string: "https:usna-sapr-app.web.app")!)
                    .font(.largeTitle)
                    .foregroundColor(ColorManager.colorPrimary)
                
                Text("Find more information about the USNA SAPR Department.")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                //Spacer()
            }
            .navigationTitle("Home")
            .onAppear{cons = readContacts()}
        }
    }
}

//struct initialSettingsView: View{
//    @Binding var isOnboardingViewShowing: Bool
//    var body: some View {
//        NavigationView{
//            ZStack {
//                Color.blue
//            }
//            .navigationTitle("Settings")
//            .navigationBarItems(trailing: isOnboardingViewShowing ? Button("Done") {
//                goHome()
//            } : nil )
//        }
//    }
//}

func goHome() {
    if let window = UIApplication.shared.windows.first{
        window.rootViewController = UIHostingController(rootView: ContentView())
        window.makeKeyAndVisible()
    }
}

