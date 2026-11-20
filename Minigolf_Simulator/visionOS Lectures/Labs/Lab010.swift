//  visionOS Lectures - Labs
//
//  Title: Lab010
//
//  Subtitle: Scene Extension
//
//  Description: Shows how to load and extend a scene from Reality Composer Pro
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab010: View {
    
    @Environment(\.realityKitScene) var scene
    
    @State var root = Entity()
    @State var showAxes = true
    @State var sphere = Entity()
    
    @State var xAxisLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("X").font(.largeTitle)), BillboardComponent()])
    @State var yAxisLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("Y").font(.largeTitle)), BillboardComponent()])
    @State var zAxisLabel = Entity(components: [ViewAttachmentComponent(rootView: Text("Z").font(.largeTitle)), BillboardComponent()])
    
    init() {
        registerComponentsAndSystems()
    }
    
    func registerComponentsAndSystems() {
        DrawComponent.registerComponent()
        DrawRuntimeComponent.registerComponent()
        
        DrawSystem.registerSystem()
    }
    
    var body: some View {
        // Same views as in Lab001, only this time root is loaded from Reality Composer Pro
        RealityView { content in
            if let scene = try? await Entity(named: "Lab010"),
               let sceneRoot = scene.findEntity(named: "Root") {
                // Scene itself is also an entity, but we want to use the "Root" entity as root
                root = sceneRoot
                
                setupRoot()
                setupSphere()

                root.addChild(sphere)
                content.add(root)
            }
        }
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .onChange(of: showAxes) { oldValue, newValue in
            xAxisLabel.isEnabled = newValue
            yAxisLabel.isEnabled = newValue
            zAxisLabel.isEnabled = newValue
            
            scene?.performQuery(DrawSystem.query).forEach { entity in
                entity.drawComponent?.showAxes = newValue
            }
        }
        .hoverRotatable(for: root)
    }
    
    var ornamentUI: some View {
        VStack {
            Toggle(isOn: $showAxes.animation()) {
                Text(showAxes ? "Hide Axes" : "Show Axes")
            }
            .toggleStyle(.button)
        }
        .padding()
        .fixedSize()
        .glassBackgroundEffect()
    }
    
    func setupRoot() {
        root.name = Constants.mainRoot
        
        let axisLength: Float = 0.25
        let offset: Float = 0.02
        xAxisLabel.position.x = axisLength + offset
        yAxisLabel.position.y = axisLength + offset
        zAxisLabel.position.z = axisLength + offset
        
        root.addChild(xAxisLabel)
        root.addChild(yAxisLabel)
        root.addChild(zAxisLabel)
    }
    
    func setupSphere() {
        var material = UnlitMaterial(color: .cyan)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.8))
        
        sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.015),
            materials: [material])
        sphere.name = "Sphere"
        sphere.position = [0.1, 0.1, 0.1]
        
        var manipulationComponent = ManipulationComponent()
        manipulationComponent.releaseBehavior = .stay
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        sphere.components.set(manipulationComponent)
        sphere.generateCollisionShapes(recursive: true)
        sphere.components.set(InputTargetComponent())
        sphere.components.set(HoverEffectComponent())
        sphere.components.set(DrawComponent(showAxes: showAxes))
        sphere.components.set(DrawRuntimeComponent())
    }
}

#Preview(windowStyle: .volumetric) {
    Lab010()
}
