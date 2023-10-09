//
//  EditSheetView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 07/10/2023.
//

import SwiftUI

enum UpdateType {
    case email, username
}

struct EditSheetView: View {
    @Binding var isPresented: Bool
    var title: String
    @Binding var text: String
    var updateType: UpdateType
    @EnvironmentObject var personTabViewModel: PersonTabViewModel
    
    @State private var showError: Bool = false

    var body: some View {
        VStack {
            Text(title)
                .bold()
                .font(.system(size: 20))
                .padding(.bottom, 20)
                .padding(.top, 30)

            TextField("Enter \(title.lowercased())", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .padding(.bottom, 15)
                .accentColor(AppColors.originalGreen)
                .onChange(of: text) { newValue in
                    switch updateType {
                    case .email:
                        personTabViewModel.newEmail = newValue
                    case .username:
                        personTabViewModel.newUsername = newValue
                    }
                }

            if personTabViewModel.errorMessage != nil {
                Text(personTabViewModel.errorMessage ?? "Unknown error")
                    .foregroundColor(.red)
                    .padding(.bottom, 15)
            }

            Button(action: {
                switch updateType {
                case .email:
                    personTabViewModel.updateEmail()
                case .username:
                    personTabViewModel.updateUsername()
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 100, height: 40)
                    .background(AppColors.darkerGreen)
                    .cornerRadius(10.0)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.horizontal)
    }
}

struct EditSheetView_Previews: PreviewProvider {
    @State static var mockIsPresented: Bool = true
    @State static var mockText: String = "Example Text"
    
    static var previews: some View {
        EditSheetView(isPresented: $mockIsPresented, title: "Edit Email", text: $mockText, updateType: .email)
    }
}
