//
//  VectorDisplay.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 20.10.25.
//

import SwiftUI
import RealityKit

struct VectorDisplay: View {
    let title: String
    let vector: SIMD3<Float>

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .fontWeight(.bold)
            
            HStack {
                ForEach(["X", "Y", "Z"], id: \.self) { axis in
                    let value = axis == "X" ? vector.x : axis == "Y" ? vector.y : vector.z
                    HStack {
                        Text("\(axis):")
                            .fontWeight(.bold)
                        Text(String(format: "%8.3f", value.isNaN ? 0 : value))
                    }
                    .frame(width: 150, alignment: .leading)
                }
            }
        }
    }
}
