//
//  PersonTabView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 15/09/2023.
//

import SwiftUI

struct PersonTabView: View {
    var body: some View {
        NavigationView {
            PersonTabContent()
        }
    }

    func PersonTabContent() -> some View {
        VStack {
            Text("Person")
        }
    }
}

struct PersonTabView_Previews: PreviewProvider {
    static var previews: some View {
        PersonTabView()
    }
}
