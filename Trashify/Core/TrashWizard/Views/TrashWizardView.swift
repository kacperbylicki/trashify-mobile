//
//  TrashWizardView.swift
//  Trashify
//
//  Created by Kacper Bylicki on 26/10/2023.
//

import SwiftUI
import AVFoundation

enum Constants {
    static let buttonCornerRadius: CGFloat = 10.0
    static let padding: CGFloat = 20.0
    static let imageCornerRadius: CGFloat = 8
}

enum TrashWizardConstants {
    static let buttonCornerRadius: CGFloat = 10.0
    static let padding: CGFloat = 20.0
    static let imageCornerRadius: CGFloat = 8
}

struct TrashWizardView: View {
    @EnvironmentObject var darkModeManager: DarkModeManager
    @StateObject private var trashWizardViewModel = TrashWizardViewModel()
    @State private var showAlert = false
    @State private var showCameraAccessAlert = false
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @State private var alertMessage = ""

    @ObservedObject private var locationManager = LocationManager()

    var body: some View {
        VStack(spacing: 25) {
            imageSection
            trashTypePickerSection
            locationFieldSection
            saveButtonSection
            Spacer()
        }
        .padding(.top, Constants.padding + 10)
        .padding(.horizontal, Constants.padding)

    }
    
    private var imageSection: some View {
        Group {
            if let img = image {
                SelectedImageView(img: img) { self.image = nil }
            } else {
                ImagePickerButton(onTapped: requestCameraAccess)
                    .alert(isPresented: $showCameraAccessAlert) {
                        Alert(title: Text("No access to camera"),
                              message: Text("Please share access in settings."),
                              dismissButton: .default(Text("OK")))
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                            .background(Color.black)
                    }
            }
        }
        .onChange(of: image) { newImage in
            if let img = newImage {
                let classifiedTrashType = trashWizardViewModel.getTrashTypeFromImageClassification(img)
                trashWizardViewModel.trashType = classifiedTrashType
            }
        }
    }
    
    private var trashTypePickerSection: some View {
        HStack {
            Picker("Select trash type", selection: $trashWizardViewModel.trashType) {
                ForEach(TrashType.allCases) { trashType in
                    Text(trashType.rawValue.capitalizeFirstLetterOfEachWord()).tag(trashType)
                }
            }
            .accentColor(darkModeManager.isDarkMode ? Color.white : AppColors.darkGray)
            .padding(.horizontal, TrashWizardConstants.padding)
        }
        .disabled(trashWizardViewModel.trashType == .none)
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.darkerGreen, lineWidth: 3)
        )
        .cornerRadius(10)
        .padding(.horizontal, TrashWizardConstants.padding)
    }
    
    private var locationFieldSection: some View {
        HStack {
            TextField("Location", text: $trashWizardViewModel.location)
                .autocapitalization(.none)
                .frame(height: 50)
                .padding(.horizontal, TrashWizardConstants.padding)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.darkerGreen, lineWidth: 3)
            )
        }
        .foregroundColor(.white)
        .background(AppColors.darkerGreen)
        .disabled(true)
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .font(.system(size: 15))
        .cornerRadius(10)
        .padding(.horizontal, TrashWizardConstants.padding)
        .onAppear(perform: fetchLocation)
        .onChange(of: locationManager.placemark) { newPlacemark in
            if let placemark = newPlacemark {
                let latitude = placemark.location?.coordinate.latitude
                let longitude = placemark.location?.coordinate.longitude
                
                if let lat = latitude, let lon = longitude {
                    trashWizardViewModel.coordinates = [lon, lat]
                }
                
                trashWizardViewModel.location = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "")"
            }
        }
    }
    
    private var saveButtonSection: some View {
        Button("Save") {
            Task {
                do {
                    try await trashWizardViewModel.createTrash()
                    
                    trashWizardViewModel.trashType = .none
                    trashWizardViewModel.coordinates = []
                    self.image = nil
                    
                    alertMessage = "Trash created successfully"
                    showAlert = true
                } catch let error {
                    trashWizardViewModel.trashType = .none
                    trashWizardViewModel.coordinates = []
                    self.image = nil
                    
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .font(.system(size: 15))
        .fontWeight(.bold)
        .background(AppColors.darkerGreen)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
        .shadow(color: AppColors.darkerGreen.opacity(0.2), radius: 10, x: 0, y: 10)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertMessage == "Trash created successfully" ? "Success" : "Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")) {
                      showAlert = false
                  })
        }
    }

    private func fetchLocation() {
        locationManager.requestLocationAuthorization()
    }

    private func requestCameraAccess() {
        CameraAccessService.requestAccess { hasAccess in
            if hasAccess {
                self.showImagePicker = true
            } else {
                self.showCameraAccessAlert = true
            }
        }
    }
}

struct SelectedImageView: View {
    let img: UIImage
    let onImageRemoved: () -> Void
    
    var responsiveSize: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var body: some View {
        VStack {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width - 64, height: 250) // Adjust width based on aspect ratio
                .cornerRadius(TrashWizardConstants.imageCornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: TrashWizardConstants.buttonCornerRadius)
                        .stroke(AppColors.darkerGreen, lineWidth: 2)
                )
            
            Button(action: onImageRemoved) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .padding(TrashWizardConstants.padding)
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .font(.system(size: 15))
            .fontWeight(.bold)
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.vertical, TrashWizardConstants.padding)
            .padding(.horizontal)
            .shadow(color: AppColors.darkerGreen.opacity(0.2), radius: 10, x: 0, y: 10)
        }
        .padding(.bottom, 4 * TrashWizardConstants.padding)
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width - 64, height: responsiveSize)
        
    }
}

struct ImagePickerButton: View {
    let onTapped: () -> Void
    
    var body: some View {
        Button(action: onTapped) {
            Text("+")
                .font(.largeTitle)
                .foregroundColor(Color.white)
                .padding(Constants.padding)
                .frame(width: UIScreen.main.bounds.width - 64, height: 100)
                .background(AppColors.darkerGreen)
                .cornerRadius(Constants.buttonCornerRadius)
                .shadow(color: AppColors.darkerGreen.opacity(0.2), radius: 10, x: 0, y: 10)
        }
    }
}

class CameraAccessService {
    static func requestAccess(completion: @escaping (Bool) -> Void) {
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

extension String {
    func capitalizeFirstLetterOfEachWord() -> String {
        return self.components(separatedBy: " ").map { $0.capitalized }.joined(separator: " ")
    }
}

struct TrashWizardView_Previews: PreviewProvider {
    static var previews: some View {
        TrashWizardView()
    }
}
