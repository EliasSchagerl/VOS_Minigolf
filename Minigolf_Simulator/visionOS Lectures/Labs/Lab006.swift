//  visionOS Lectures - Labs
//
//  Title: Lab006
//
//  Subtitle: Direction
//
//  Description: Shows the direction of an object
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab006: View {
    
    @State var root = Entity()
    @State var sphere = Entity()
    @State var subscriptions = [EventSubscription]()
    
    @State var rootToSphereVectorVisual: Vector?
    @State var directionSphereVisual: Sphere?
    
    let modelSortGroup = ModelSortGroup()
        
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
            setupModelSorting()

            root.addChild(sphere)
            content.add(root)
            
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, componentType: DrawComponent.self, { event in
                handleUpdate(for: event)
            }))
        }
        .scaleEffect(0.5) // Scaled to avoid content clipping
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .hoverRotatable(for: root)
        .preferredWindowClippingMargins(.all, 1000)
    }
    
    var ornamentUI: some View {
        VStack(alignment: .leading, spacing: 10) {
            let directionVector = normalize(sphere.observable.position - root.observable.position)
            
            VectorDisplay(title: "Direction", vector: directionVector)
            
            HStack {
                Text("Length")
                    .fontWeight(.bold)
                
                Text(String(format: "%8.3f", length(directionVector)))
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
        .glassBackgroundEffect()
    }
    
    func setupRoot() {
        root.components.set(DrawComponent(showAxes: true))
        root.components.set(DrawRuntimeComponent())
        root.name = Constants.mainRoot
        root.addAxes()
    }
    
    func setupSphere() {
        var material = UnlitMaterial(color: .yellow)
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
        rootToSphereVectorVisual = sphere.addVector(
            from: root.position,
            to: normalize(sphere.position),
            color: .yellow
        )
        
        directionSphereVisual = root.addSphere(
            to: root,
            radius: 1,
            color: .white,
            opacity: 0.1
        )
    }
    
    func setupModelSorting() {
        root.drawRuntimeComponent?.axes?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 0))
        sphere.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 1))
        rootToSphereVectorVisual?.visualEntity?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 2))
        directionSphereVisual?.visualEntity?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 3))
    }
    
    func handleUpdate(for event: Event) {
        sphere.updateVector(with: rootToSphereVectorVisual?.id) { vector in
            vector.start = root.position
            vector.end = normalize(sphere.position)
        }
    }
}

#Preview(windowStyle: .volumetric) {
    Lab006()
}
