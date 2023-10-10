//
//  LocationSearchView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 16/09/2023.
//

import SwiftUI
import MapKit

struct LocationSearchView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    @State private var startLocationText = ""
    @Binding var showLocationSearchView: Bool

    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    var body: some View {
        VStack {
            LocationSearchViewActionButton(showLocationSearchView: $showLocationSearchView).padding(.top, 50)

            HStack {
                TextField("Location", text: $locationViewModel.searchFragment).frame(height: 50).background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white).foregroundColor(darkModeManager.isDarkMode ? .gray : Color(.darkGray)).padding(.horizontal, 20).font(.system(size: 15))
            }
                    .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                    .background(darkModeManager.isDarkMode ? AppColors.darkGray : Color.white)
                    .cornerRadius(50)
                    .shadow(color: .green.opacity(0.1), radius: 10, x: 0, y: 10)
                    .padding(.top, 25)

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationViewModel.searchResults, id: \.self) { searchResult in
                        LocationSearchResultCell(title: searchResult.title, subtitle: searchResult.subtitle).onTapGesture {
                            withAnimation(.spring()) {
                                locationViewModel.selectLocation(searchResult)
                                showLocationSearchView.toggle()
                            }
                        }
                    }
                }
            }
        }
                .padding(.horizontal).background(Color(.systemGroupedBackground))
                .edgesIgnoringSafeArea(.all)
    }
}


struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(showLocationSearchView: .constant(false))
    }
}
