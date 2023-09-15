//
//  BottomNavigationView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 09/09/2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case plusCircle = "plus.circle"
    case person
}

struct BottomNavigationView: View {
    @Binding var selectedTab: Tab
    @Binding var isPlusSheetPresented: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                TabButton(tab: tab, selectedTab: $selectedTab, isPlusSheetPresented: $isPlusSheetPresented)
                Spacer()
            }
        }
        .padding(.horizontal, 32)
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .blue.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    @Binding var isPlusSheetPresented: Bool
    
    var body: some View {
        Image(systemName: tab == selectedTab ? tab.rawValue + ".fill" : tab.rawValue)
            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
            .foregroundColor(tab == selectedTab ? Color(#colorLiteral(red: 0.372549027, green: 0.721568644, blue: 0.494117647, alpha: 1)) : .gray)
            .font(.system(size: 20))
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.1)) {
                    if tab == .plusCircle {
                        isPlusSheetPresented = true
                    } else if tab == .person {
                        isPlusSheetPresented = false
                        selectedTab = tab
                    } else {
                        isPlusSheetPresented = false
                        selectedTab = tab
                    }
                }
            }
    }
}
