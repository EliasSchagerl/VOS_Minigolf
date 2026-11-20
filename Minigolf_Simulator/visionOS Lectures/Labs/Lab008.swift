//  visionOS Lectures - Labs
//
//  Title: Lab008
//
//  Subtitle: Look At Detection
//
//  Description: "Shows the effect of detecting if an object looks at another one"
//
//  Type: Volume
//
//  Created by Tempuno e.U. on 20.10.25.

import RealityKit
import RCPCustomComponents
import SwiftUI

struct Lab008: View {
    
    @State var box = Entity()
    @State var root = Entity()
    @State var sphere = Entity()
    @State var subscriptions = [EventSubscription]()
    @State var preciseness: Float = 0.9
    @State var lookness: Float = 0
    
    @State var boxForwardVectorVisual: Vector?
    @State var boxToSphereDirectionVisual: Vector?
    @State var boxToSphereDotProductVisual: Vector?
    @State var lookAtConeVisual: Cone?
    
    let modelSortGroup = ModelSortGroup()
            
    init() {
        registerComponentsAndSystems()
    }
    
    func registerComponentsAndSystems() {
        DrawComponent.registerComponent()
        DrawRuntimeComponent.registerComponent()
        LookAtDetectionComponent.registerComponent()
        LookAtDetectionRuntimeComponent.registerComponent()
        
        DrawSystem.registerSystem()
        LookAtDetectionSystem.registerSystem()
    }
    
    var body: some View {
        RealityView { content in
            setupSphere()
            setupBox()
            setupRoot()
            setupVisualizations()
            setupModelSorting()
            
            root.addChild(box)
            root.addChild(sphere)
            
            content.add(root)
            
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, componentType: DrawComponent.self, { event in
                handleUpdate(for: event)
            }))
            
            subscriptions.append(content.subscribe(to: ComponentEvents.DidChange.self, componentType: LookAtDetectionComponent.self, { event in
                handleLookAtDetectionDidChange(for: event)
            }))
        }
        .ornament(attachmentAnchor: .scene(.topBack)) {
            ornamentUI
        }
        .onChange(of: box.observable.position, initial: true) { _ , newValue in
            updateLookness(with: box.lookAtDetectionRuntimeComponent?.target.observable.position)
        }
        .onChange(of: box.lookAtDetectionRuntimeComponent?.target.observable.position, initial: true) { _ , newValue in
            updateLookness(with: newValue)
        }
        .hoverRotatable(for: root)
        .preferredWindowClippingMargins(.all, 1000)
    }
    
    var ornamentUI: some View {
        VStack(alignment: .leading, spacing: 10) {
            let lookDirection = box.transform.matrix.forward

            VectorDisplay(title: "Look Direction", vector: lookDirection)
            
            HStack {
                Text("Lookness")
                    .fontWeight(.bold)
                
                Text(String(format: "%.3f", lookness))
            }
            
            precisenessSlider
        }
        .padding(.horizontal, 40)
        .padding(.vertical)
        .glassBackgroundEffect()
    }
    
    var precisenessSlider: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Preciseness")
                    .fontWeight(.bold)
                
                Text(String(format: "%.3f", preciseness))
            }
            
            Slider(value: $preciseness, in: 0.001...1)
                .onChange(of: preciseness, initial: true) { oldValue, newValue in
                    root.scene?.performQuery(DrawSystem.query).forEach { entity in
                        entity.drawRuntimeComponent?.cones.enumerated().forEach { index, sphere in
                            entity.drawRuntimeComponent?.cones[index].height = newValue
                            entity.drawRuntimeComponent?.cones[index].radius = xFromY(newValue)
                        }
                    }
                    
                    root.scene?.performQuery(LookAtDetectionSystem.query).forEach { entity in
                        entity.lookAtDetectionComponent?.preciseness = newValue
                    }
                }
        }
    }
    
    func setupRoot() {
        root.components.set(DrawComponent(showAxes: true))
        root.components.set(DrawRuntimeComponent())
        root.name = Constants.mainRoot
        root.addAxes()
    }
    
    func setupSphere() {
        var material = UnlitMaterial(color: .cyan)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.8))
        
        sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.015),
            materials: [material])
        sphere.name = "Sphere"
        sphere.position = [-0.1, 0.1, 0.1]
        
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
    
    func setupBox() {
        var material = UnlitMaterial(color: .orange)
        material.blending = .transparent(opacity: PhysicallyBasedMaterial.Opacity(floatLiteral: 0.8))
        
        box = ModelEntity(
            mesh: .generateBox(size: 0.03),
            materials: [material])
        box.name = "Box"
        box.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
        box.orientation *= simd_quatf(angle: -.pi / 8, axis: [1, 0, 0])
        box.position = [-0.1, 0, 0.1]
        
        var manipulationComponent = ManipulationComponent()
        manipulationComponent.releaseBehavior = .stay
        manipulationComponent.dynamics.scalingBehavior = .none
        manipulationComponent.dynamics.inertia = .zero
        box.components.set(manipulationComponent)
        box.generateCollisionShapes(recursive: true)
        box.components.set(InputTargetComponent())
        box.components.set(HoverEffectComponent())
        box.components.set(DrawComponent())
        box.components.set(DrawRuntimeComponent())
        box.components.set(LookAtDetectionComponent(preciseness: preciseness))
        box.components.set(LookAtDetectionRuntimeComponent(target: sphere))
    }
    
    func setupVisualizations() {
        boxForwardVectorVisual = box.addVector(
            from: box.position,
            to: box.transform.matrix.forward,
            color: .orange
        )
        
        boxToSphereDirectionVisual = box.addVector(
            from: box.position,
            to: normalize(sphere.position - box.position) + box.position, // + box.position as offset for correct visualization
            color: .yellow
        )
            
        boxToSphereDotProductVisual = box.addVector(
            from: box.position,
            to: normalize(sphere.position - box.position) * lookness + box.position, // + box.position as offset for correct visualization
            color: .white
        )
        
        lookAtConeVisual = box.addCone(
            to: box.position + ((box.transform.matrix.forward / 2)),
            height: preciseness,
            radius: xFromY(preciseness),
            color: .white,
            opacity: 0.2
        )
    }
    
    func setupModelSorting() {
        root.drawRuntimeComponent?.axes?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 0))
        sphere.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 1))
        box.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 1))
        lookAtConeVisual?.visualEntity?.components.set(ModelSortGroupComponent(group: modelSortGroup, order: 2))
    }
    
    func handleUpdate(for event: Event) {
        box.updateVector(with: boxForwardVectorVisual?.id) { vector in
            vector.start = box.position
            vector.end = box.position + box.transform.matrix.forward
        }
        
        box.updateVector(with: boxToSphereDirectionVisual?.id) { vector in
            vector.start = box.position
            vector.end = normalize(sphere.position - box.position) + box.position // + box.position as offset for correct visualization
        }
        
        box.updateVector(with: boxToSphereDotProductVisual?.id) { vector in
            vector.start = box.position
            vector.end = normalize(sphere.position - box.position) * lookness + box.position // + box.position as offset for correct visualization
        }
        
        box.updateCone(with: lookAtConeVisual?.id) { cone in
            cone.position = box.position + ((box.transform.matrix.forward / 2) * (cone.height)) // * cone.height since the height also changes the y-scale
        }
    }   
    
    func handleLookAtDetectionDidChange(for event: ComponentEvents.DidChange) {
        guard let lookAtDetectionComponent = event.entity.lookAtDetectionComponent else { return }
        
        event.entity.updateCone(with: lookAtConeVisual?.id) { cone in
            cone.color = lookAtDetectionComponent.isTriggered ? .green : .white
        }
        
        event.entity.updateVector(with: boxToSphereDotProductVisual?.id) { vector in
            vector.color = lookAtDetectionComponent.isTriggered ? .green : .white
        }
    }
    
    // Helper method to get x-Position from a given y-Position and radius => Pythagoras (x^2 + y^2 = r^2)
    func xFromY(_ y: Float, radius r: Float = 1.0) -> Float {
        guard abs(y) <= r else { return 0 }
        return sqrt(r * r - y * y)
    }
    
    func updateLookness(with targetPosition: SIMD3<Float>?) {
        if let targetPosition {
            let objectPosition = box.observable.position
            let objectToTargetPosition = normalize(targetPosition - objectPosition)
            let lookDirection = box.transform.matrix.forward
            
            lookness = dot(objectToTargetPosition, lookDirection)
        }
    }
}

#Preview(windowStyle: .volumetric) {
    Lab008()
}
