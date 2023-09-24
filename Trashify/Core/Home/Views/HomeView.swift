//
//  HomeView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 09/09/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchView = true
    
    var body: some View {
        NavigationView {
            HomeContent()
        }
    }

    func HomeContent() -> some View {
        ZStack(alignment: .top) {
            MapViewRepresentable().ignoresSafeArea()
            
            VStack(alignment: .leading) {
                if !showLocationSearchView {
                    LocationSearchView(showLocationSearchView: $showLocationSearchView)
                } else {
                    LocationSearchActivationView().padding(.vertical, 50).onTapGesture {
                        withAnimation(.spring()) {
                            showLocationSearchView.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
