//
//  DarkModeManager.swift
//  Trashify
//
//  Created by Marek Gerszendorf on 10/10/2023.
//

import SwiftUI
import Combine

class DarkModeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
}
