//
//  LabRouter.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 20.10.25.
//

import SwiftUI

struct LabRouter: View {

    @Environment(ModelData.self) var modelData
    @Binding var route: String?

    var body: some View {
        lab
            .ornament(attachmentAnchor: .scene(.bottomFront)) {
                if let route, let subtitle = modelData.labData.first(where: { $0.title == route })?.subtitle {
                    Text(subtitle)
                        .font(.largeTitle)
                        .padding(20)
                        .glassBackgroundEffect()
                }
            }
    }

    @ViewBuilder
    var lab: some View {
        switch route {
        case "Minigolf": LabMinigolf()
        case .none, .some:
            VStack {
                Text("No View could be found for " + (route ?? ""))
                    .font(.largeTitle)
                    .padding(12)
            }
            .background(.red)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}
