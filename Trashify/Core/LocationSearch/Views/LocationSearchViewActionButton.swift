//
//  LocationSearchViewActionButton.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import SwiftUI

struct LocationSearchViewActionButton: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    @Binding var showLocationSearchView: Bool

    var body: some View {
        Button {
            withAnimation(.spring()) {
                showLocationSearchView.toggle()
            }
        } label: {
            Image(systemName: "arrow.left")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.originalGreen)
                    .padding()
                    .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                    .clipShape(Circle())
                    .shadow(color: .green.opacity(0.1), radius: 10, x: 0, y: 10)
        }
                .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LocationSearchViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchViewActionButton(showLocationSearchView: .constant(true))
    }
}
