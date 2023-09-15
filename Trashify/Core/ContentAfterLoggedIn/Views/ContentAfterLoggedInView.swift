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
        VStack {
            if selectedTab == .house {
                HomeView()
            } else if selectedTab == .person {
                PersonTabView()
            }
            BottomNavigationView(selectedTab: $selectedTab, isPlusSheetPresented: $isPlusSheetPresented)
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
