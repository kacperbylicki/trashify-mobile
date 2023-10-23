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
    @StateObject var trashTagsViewModel = TrashTagsViewModel()
    @StateObject var userManagementViewModel = UserManagementViewModel()
    @StateObject var resetPasswordViewModel = ResetPasswordViewModel()
    @StateObject var resendVerificationViewModel = ResendVerificationViewModel()
    @StateObject var darkModeManager = DarkModeManager()
    
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView().environmentObject(locationViewModel).environmentObject(loginViewModel).environmentObject(userManagementViewModel).environmentObject(trashTagsViewModel).environmentObject(resetPasswordViewModel).environmentObject(resendVerificationViewModel).environmentObject(darkModeManager)
        }
    }
}
