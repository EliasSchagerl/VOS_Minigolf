//
//  DirectoryModel.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 20.10.25.
//

import SwiftUI

enum LabType: String {
    case WINDOW  = "Window Content"
    case WINDOW_ALT  = "Plain Window Content"
    case VOLUME = "Volume Content"
    case SPACE = "Mixed Immersive Space"
    case SPACE_FULL = "Full Immersive Space"
}

struct Lab: Identifiable {
    let id = UUID()
    var type: LabType
    var isFeatured = false
    var title: String
    var subtitle: String
    var description: String
    var success: Bool = true

    init(title: String, type: LabType, isFeatured: Bool = false, subtitle: String, description: String, success: Bool = true) {
        self.title = title
        self.type = type
        self.isFeatured = isFeatured
        self.subtitle = subtitle
        self.description = description
        self.success = success
    }
}

@Observable
class ModelData {
    var labData: [Lab] = [
        Lab(title: "Minigolf",
            type: .SPACE,
            isFeatured: true,
            subtitle: "Mixed-Reality Minigolf",
            description: "Greife den Hebel und ziehe ihn nach unten, um das Minigolf-Setup zu erzeugen.")
    ]
}
