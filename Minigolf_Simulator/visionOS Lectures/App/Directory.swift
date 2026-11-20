//
//  ContentView.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 20.10.25.
//

import SwiftUI
import RealityKit

struct Directory: View {

    var body: some View {
        NavigationStack {
            LabList()
        }
        .padding(EdgeInsets(top: 36, leading: 0, bottom: 0, trailing: 0))
        .ornament(attachmentAnchor: .scene(.top)) {
            HStack {
                Image(systemName: "vision.pro")
                Text("visionOS Lectures")
            }
            .font(.largeTitle)
            .padding(20)
            .background(.thickMaterial)
            .glassBackgroundEffect()
            .cornerRadius(20)
        }
    }
}

#Preview(windowStyle: .automatic) {
    let modelData = ModelData()
    return Directory()
        .environment(modelData)
}
