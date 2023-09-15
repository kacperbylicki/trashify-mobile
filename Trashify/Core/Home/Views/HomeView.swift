//
//  HomeView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 09/09/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            HomeContent()
        }
    }

    func HomeContent() -> some View {
        VStack {
            Text("Home View")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
