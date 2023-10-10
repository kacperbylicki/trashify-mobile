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
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .green.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    @Binding var isPlusSheetPresented: Bool
    
    var body: some View {
        Image(systemName: tab == selectedTab ? tab.rawValue + ".fill" : tab.rawValue)
            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
            .foregroundColor(tab == selectedTab ? AppColors.originalGreen : .gray)
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
