//
//  AppSettingsView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

struct AppSettingsView: View {
    var openAppSettings: () -> Void
    @EnvironmentObject var darkModeManager: DarkModeManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack() {
            HStack {
                Text("App settings")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(Color.primary)
                    .padding(.bottom, 20)
                    .padding(.top, 15)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Button(action: openAppSettings) {
                    Image(systemName: "gearshape")
                    Text("Access settings")
                }
                .foregroundColor(Color.primary)
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Image(systemName: "moon.fill")
                    .foregroundColor((darkModeManager.isDarkMode ) ? .yellow : .gray)
                Toggle("Dark mode", isOn: Binding(
                    get: { darkModeManager.isDarkMode },
                    set: { newValue in
                        darkModeManager.isDarkMode = newValue
                    }
                ))
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
        .cornerRadius(20)
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView(openAppSettings: {})
    }
}
