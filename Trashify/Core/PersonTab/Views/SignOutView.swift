//
//  SignOutView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

struct SignOutView: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    var body: some View {
        VStack() {
            HStack {
                Button(action: {
                    Task {
                        await viewModel.logout()
                    }
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                    Text("Sign out")
                }
                .foregroundColor(Color.primary)
                .padding()
                Spacer()
            }
            
            Spacer()
        }
        .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SignOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignOutView()
    }
}
