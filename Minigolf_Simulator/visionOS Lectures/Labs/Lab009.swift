//  visionOS Lectures - Labs
//
//  Title: Lab009
//
//  Subtitle: Scene Loading
//
//  Description: Shows how to load a scene from Reality Composer Pro
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab009: View {
    
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Lab009") {
                content.add(scene)
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    Lab009()
}
