//  visionOS Lectures - Labs
//
//  Title: Lab012
//
//  Subtitle: Prefabs
//
//  Description: Shows a scene with different prefabs
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab012: View {
    
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Lab012") {
                scene.position.y = -0.4
                content.add(scene)
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    Lab012()
}
