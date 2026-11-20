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
    var date: Date
    var title: String
    var subtitle: String
    var description: String
    var success: Bool = true

    init(title: String, type: LabType, date: Date, isFeatured: Bool = false, subtitle: String, description: String, success: Bool = true) {
        self.title = title
        self.type = type
        self.isFeatured = isFeatured
        self.date = date
        self.subtitle = subtitle
        self.description = description
        self.success = success
    }
}


@Observable
class ModelData {
    
    var labData: [Lab] = [
        Lab(title: "Lab 001",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Axes Example",
            description: "Shows the Axes / Gizmo of an object"),
        Lab(title: "Lab 002",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "World, Local & Object Space",
            description: "Shows the movement in World, Local and Object Space"),
        Lab(title: "Lab 003",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Vector Example",
            description: "Shows the vector of an object"),
        Lab(title: "Lab 004",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Vector Addition",
            description: "Visualizes the addition of two vectors"),
        Lab(title: "Lab 005",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Vector Subtraction",
            description: "Visualizes the subtraction of two vectors"),
        Lab(title: "Lab 006",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Direction",
            description: "Shows the direction of an object"),
        Lab(title: "Lab 007",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Trigger",
            description: "Shows the effect of a trigger"),
        Lab(title: "Lab 008",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Look At Detection",
            description: "Shows the effect of detecting if an object looks at another one"),
        Lab(title: "Lab 009",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Scene Loading",
            description: "Shows how to load a scene from Reality Composer Pro"),
        Lab(title: "Lab 010",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Scene Extension",
            description: "Shows how to load and extend a scene from Reality Composer Pro"),
        Lab(title: "Lab 011",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Textures",
            description: "Shows the use of different textures in Reality Composer Pro"),
        Lab(title: "Lab 012",
            type: .VOLUME,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Prefabs",
            description: "Shows a scene with different prefabs"),
        Lab(title: "Lab 013",
            type: .WINDOW,
            date: Date("10/20/2024"),
            isFeatured: false,
            subtitle: "Accessibility",
            description: "Shows good and bad practices about supporting accessibility")
    ]
}
