//
//  AppSettingsView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

struct AppSettingsView: View {
    var openAppSettings: () -> Void
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack() {
            HStack {
                Text("App settings")
                    .bold()
                    .font(.system(size: 20))
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
                .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Image(systemName: "moon.fill")
                    .foregroundColor(isDarkMode ? .yellow : .gray)
                Toggle("Dark mode", isOn: $isDarkMode)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(.white)
        .cornerRadius(20)
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    @State static var mockIsDarkMode: Bool = false
    
    static var previews: some View {
        AppSettingsView(openAppSettings: {
        }, isDarkMode: $mockIsDarkMode)
    }
}
