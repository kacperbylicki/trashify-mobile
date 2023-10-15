//
//  AddTagsView.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 15/10/2023.
//

import SwiftUI
import AVFoundation

struct AddTagsView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    @State private var showAlert = false
    @State private var showImagePicker = false
    @State private var image: UIImage?

    var body: some View {
        VStack {
            if let img = image {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .cornerRadius(8)

                    Button(action: {
                        self.image = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding(30)
                }
            } else {
                Button(action: {
                    requestCameraAccess { hasAccess in
                        if hasAccess {
                            self.showImagePicker = true
                        } else {
                            self.showAlert = true
                        }
                    }
                }) {
                    Text("+")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 140, height: 60)
                        .background(AppColors.darkerGreen)
                        .cornerRadius(10.0)
                }
                .padding(.top, 50)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("No access to camera"), message: Text("Please share access in settings."), dismissButton: .default(Text("OK")))
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $image)
                }
            }

            Spacer()
        }
    }

    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { response in
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        default:
            completion(false)
        }
    }
}

struct AddTagsView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagsView()
    }
}
