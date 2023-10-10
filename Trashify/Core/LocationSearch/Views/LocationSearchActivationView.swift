//
//  LocationSearchActivationView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import SwiftUI

struct LocationSearchActivationView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(AppColors.originalGreen)
                .padding(.horizontal)

            Text("What location are you looking for?").foregroundColor(darkModeManager.isDarkMode ? .gray : Color(.darkGray)).font(.system(size: 15))

            Spacer()
        }
                .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                .cornerRadius(50)
                .shadow(color: .green.opacity(0.1), radius: 10, x: 0, y: 10)
                .padding(.top, 25)
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
