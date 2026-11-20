//  visionOS Lectures - Labs
//
//  Title: Lab013
//
//  Subtitle: Accessibility
//
//  Description: Shows good and bad practices about supporting accessibility
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab013: View {
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // MARK: - Good Accessibility Example
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Good Accessibility Example")
                            .font(.title)
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        
                        Text("""
This section demonstrates good VoiceOver and Dynamic Type support.
The content is scrollable, text scales naturally, and controls are
clearly described for VoiceOver users.
""")
                        .font(.body)
                        
                        Button {
                            // Action here
                        } label: {
                            Text("Start Experiment")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .accessibilityLabel("Start experiment")
                        .accessibilityHint("Begins the lab experience")
                        
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .accessibilityHidden(true)
                            
                            Text("Audio guidance is enabled")
                                .font(.subheadline)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Audio guidance is enabled")
                    }
                    
                    Divider()
                    
                    // MARK: - Good Accessibility Example (RealityView)
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Accessible RealityView Example")
                            .font(.title2)
                            .bold()
                            .accessibilityAddTraits(.isHeader)
                        
                        Text("""
This RealityView contains a 3D entity that is accessible to VoiceOver
using an AccessibilityComponent. VoiceOver users can focus on the entity
and hear a meaningful description.
""")
                        .font(.body)
                        
                        RealityView { content in
                            // Simple visible entity
                            let mesh = MeshResource.generateBox(size: 0.02)
                            let material = SimpleMaterial(color: .blue, isMetallic: false)
                            let boxEntity = ModelEntity(mesh: mesh, materials: [material])
                            
                            // ✅ Accessibility for RealityKit entity
                            var accessibilityComponent = AccessibilityComponent()
                            accessibilityComponent.isAccessibilityElement = true
                            accessibilityComponent.label = "Blue cube"
                            accessibilityComponent.value = "A virtual object used for demonstration purposes"
                            accessibilityComponent.traits = [.button]
                            boxEntity.components.set(accessibilityComponent)
                            
                            boxEntity.position = [0, 0, -0.15]
                            content.add(boxEntity)
                        }
                        .frame(height: 100)
                    }
                }
            }
            .accessibilityElement(children: .contain)
            
            Divider()
                .padding()
            
            // MARK: - Bad Accessibility Example
            VStack(alignment: .leading, spacing: 16) {
                Text("Bad Accessibility Example")
                    .font(.title)
                    .bold()
                
                // ❌ Fixed font + fixed height causes clipping
                Text("""
This is a long block of text that will get cut off when the user enables
larger Dynamic Type sizes. The frame height is fixed, so the text cannot
expand naturally and becomes unreadable.
""")
                .font(.system(size: 14)) // ❌ Fixed font
                .frame(height: 40)       // ❌ Fixed height
                .border(.red)
                .clipped()
                
                Text("""
Even though this text has no fixed font size, it still will get cut off in smaller views or when the font size gets changed in the settings since it is not in a scroll view and cannot expand.
""")
                
                // ❌ No accessibility label
                Button {
                    // Action here
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.largeTitle)
                }
                
                // ❌ Decorative image exposed to VoiceOver
                Image(systemName: "eye.slash")
                    .font(.largeTitle)
            }
        }
        .padding()
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    Lab013()
}
