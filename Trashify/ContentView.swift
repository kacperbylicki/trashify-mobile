//
//  ContentView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            if(isLoggedIn) {
                ContentAfterLoggedInView()
            } else {
                LoginPromoView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
