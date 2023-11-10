//
//  LoginPromoView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct WelcomeScreenView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    @Binding var isLoggedIn: Bool
    @State private var isShowingSignUp = false
    @State private var isShowingLogin = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 15) {
                // Header Image
                Image("nature")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 50)
                
                VStack(alignment: .leading, spacing: 10) {
                    // Header
                    Text("Kickstart Your Eco-Journey 🌱")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                    Text("Segregate waste with us and pave the way for a healthier planet!")
                        .font(.subheadline)
                        .foregroundColor(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                        .padding(.bottom, 15)
                    
                    // Registration navigation button
                    NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn), isActive: $isShowingSignUp) {
                        Button("Join Now") {
                            Task {
                                isShowingSignUp = true
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.darkerGreen)
                        .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                        .cornerRadius(10)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 64, alignment: .center)
                .padding(.horizontal)
                .padding(.bottom, 15)
                
                Spacer()
                
                // Login navigation footer
                VStack {
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                            .font(.system(size: 15))

                        NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                            Text("Login")
                                .foregroundColor(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                                .font(.system(size: 15))
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 64, alignment: .center)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .padding(.horizontal)
            .background(AppColors.darkerGreen)
        }
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    @State static private var isLoggedIn = false
    
    static var previews: some View {
        WelcomeScreenView(isLoggedIn: $isLoggedIn)
    }
}

