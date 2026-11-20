//  visionOS Lectures - Labs
//
//  Title: Lab011
//
//  Subtitle: Textures
//
//  Description: Shows the use of different textures in Reality Composer Pro
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab011: View {
    
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Lab011") {
                content.add(scene)
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    Lab011()
}
