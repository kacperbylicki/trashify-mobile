//
//  TrashifyApp.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

@main
struct TrashifyApp: App {
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var personTabViewModel = PersonTabViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(locationViewModel).environmentObject(loginViewModel).environmentObject(personTabViewModel)
        }
    }
}
