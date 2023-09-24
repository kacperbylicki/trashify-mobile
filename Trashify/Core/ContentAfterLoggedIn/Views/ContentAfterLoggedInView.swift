//
//  ContentAfterLoggedInView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 15/09/2023.
//

import SwiftUI

struct ContentAfterLoggedInView: View {
    @State private var selectedTab: Tab = .house
    @State private var isPlusSheetPresented = false
    
    var body: some View {
        ZStack {
            if selectedTab == .house {
                HomeView()
                    .edgesIgnoringSafeArea(.bottom)
            } else if selectedTab == .person {
                PersonTabView()
            }

            VStack {
                Spacer()
                BottomNavigationView(selectedTab: $selectedTab, isPlusSheetPresented: $isPlusSheetPresented)
            }
        }
        .sheet(isPresented: $isPlusSheetPresented) {
            Text("Plus")
        }
    }
}

struct ContentAfterLoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        ContentAfterLoggedInView()
    }
}
