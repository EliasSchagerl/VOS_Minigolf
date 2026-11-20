//  visionOS Lectures - Labs
//
//  Title: Lab003
//
//  Subtitle: Vector Example
//
//  Description: Shows the vector of an object
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab003: View {
    
    @State var root = Entity()
    @State var sphere = Entity()
    @State var subscriptions = [EventSubscription]()
    
    @State var rootToSphereVectorVisual: Vector?
        
    init() {
        registerComponentsAndSystems()
    }
    
    func registerComponentsAndSystems() {
        DrawComponent.registerComponent()
        DrawRuntimeComponent.registerComponent()
        
        DrawSystem.registerSystem()
    }
    
    var body: some View {
        RealityView { content in
            setupRoot()
            setupSphere()
            
            setupVisualizations()

            root.addChild(sphere)
            content.add(root)
            
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, componentType: DrawComponent.self, { event in
                handleUpdate(for: event)
            }))
        }
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .hoverRotatable(for: root)
        .preferredWindowClippingMargins(.all, 1000)
    }
    
    var ornamentUI: some View {
        VStack(alignment: .leading, spacing: 10) {
            let rootToSphereVector = sphere.observable.position - root.observable.position
            
            VectorDisplay(title: "Root To Sphere Vector", vector: rootToSphereVector)
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
        .glassBackgroundEffect()
    }
    
    func setupRoot() {
        root.components.set(DrawComponent(showAxes: true))
        root.components.set(DrawRuntimeComponent())
        root.name = Constants.mainRoot
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
        manipulationComponent.dynamics.primaryRotationBehavior = .none
        manipulationComponent.dynamics.secondaryRotationBehavior = .none
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        sphere.components.set(manipulationComponent)
        sphere.generateCollisionShapes(recursive: true)
        sphere.components.set(InputTargetComponent())
        sphere.components.set(HoverEffectComponent())
        sphere.components.set(DrawComponent())
        sphere.components.set(DrawRuntimeComponent())
    }
    
    func setupVisualizations() {
        rootToSphereVectorVisual = root.addVector(
            from: root.position,
            to: sphere.position,
            color: .cyan
        )
    }
    
    func handleUpdate(for event: Event) {
        root.updateVector(with: rootToSphereVectorVisual?.id) { vector in
            vector.start = root.position
            vector.end = sphere.position
        }
    }
}

#Preview(windowStyle: .volumetric) {
    Lab003()
}
