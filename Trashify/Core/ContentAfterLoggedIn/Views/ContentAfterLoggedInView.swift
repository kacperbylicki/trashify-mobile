//
//  ContentAfterLoggedInView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 15/09/2023.
//

import SwiftUI

struct ContentAfterLoggedInView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    @State private var selectedTab: Tab = .house
    @State private var isPlusSheetPresented = false
    
    var body: some View {
        ZStack {
            if selectedTab == .house {
                HomeView()
                    .edgesIgnoringSafeArea(.bottom)
            } else if selectedTab == .person {
                UserManagementView(selectedTab: $selectedTab)
            }

            VStack {
                Spacer()
                BottomNavigationView(selectedTab: $selectedTab, isPlusSheetPresented: $isPlusSheetPresented)
            }
        }
        .sheet(isPresented: $isPlusSheetPresented) {
            TrashWizardView()
                .environmentObject(darkModeManager)
        }
    }
}

struct ContentAfterLoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        ContentAfterLoggedInView()
    }
}
