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
    @StateObject var trashTagsViewModel = TrashTagsViewModel()
    @StateObject var darkModeManager = DarkModeManager()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView().environmentObject(locationViewModel).environmentObject(loginViewModel).environmentObject(personTabViewModel).environmentObject(trashTagsViewModel).environmentObject(darkModeManager)
        }
    }
}
