//
//  LoginPromoView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 19/08/2023.
//

import SwiftUI

struct LoginPromoView: View {
    @Binding var isLoggedIn: Bool
    @State private var isShowingSignUp = false
    @State private var isShowingLogin = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Spacer()
                
                Image("nature")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, 50)
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Let's Get Started")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Start segregating waste now and let's take care of our planet together!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .padding(.bottom, 30)
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Spacer()
                        NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn), isActive: $isShowingSignUp) {
                            Button(action: {
                                isShowingSignUp = true
                            }) {
                                Text("Join Now")
                                    .font(.headline)
                                    .foregroundColor(AppColors.darkerGreen)
                                    .padding()
                                    .frame(width: 220, height: 60)
                                    .background(.white)
                                    .cornerRadius(15.0)
                            }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        HStack {
                            Text("Already have an account?")
                                .font(.footnote)
                                .foregroundColor(.white)
                            NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn)) {
                                Text("Login")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.bottom, 20)
                        Spacer()
                    }
                    .padding()
                }
                Spacer()
                
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(AppColors.darkerGreen)
        }
        .edgesIgnoringSafeArea(.all)
    }
}


struct LoginPromoView_Previews: PreviewProvider {
    @State static private var isLoggedIn = false
    
    static var previews: some View {
        LoginPromoView(isLoggedIn: $isLoggedIn)
    }
}
