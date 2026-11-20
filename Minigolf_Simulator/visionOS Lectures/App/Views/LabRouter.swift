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
        case "Lab 001": Lab001()
        case "Lab 002": Lab002()
        case "Lab 003": Lab003()
        case "Lab 004": Lab004()
        case "Lab 005": Lab005()
        case "Lab 006": Lab006()
        case "Lab 007": Lab007()
        case "Lab 008": Lab008()
        case "Lab 009": Lab009()
        case "Lab 010": Lab010()
        case "Lab 011": Lab011()
        case "Lab 012": Lab012()
        case "Lab 013": Lab013()
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
