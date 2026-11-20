//
//  HoverRotateModifier.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 29.10.25.
//

import SwiftUI
import RealityKit

struct HoverRotateModifier: ViewModifier {
    var entity: Entity
    
    @State private var baseEntity: ModelEntity?
    @State private var lastDragValue: CGFloat = 0.0
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                addHoverBaseIfNeeded()
            }
            .gesture(rotationGesture)
    }
    
    private func addHoverBaseIfNeeded() {
        guard baseEntity == nil else { return }
        
        let material = SimpleMaterial(color: .white, isMetallic: false)
        let height: Float = 0.01
        let radius: Float = 0.3
        let base = ModelEntity(
            mesh: .generateCylinder(height: height, radius: radius),
            materials: [material]
        )
        
        base.components.set(OpacityComponent(opacity: 0.015))
        base.components.set(HoverEffectComponent(.highlight(.init(color: .white, strength: 50))))
        base.components.set(InputTargetComponent())
        base.generateCollisionShapes(recursive: true, static: true)
        
        let knob = ModelEntity(
            mesh: .generateSphere(radius: radius * 0.05),
            materials: [material]
        )
        knob.position = [0, 0, radius * 1.2]
        base.addChild(knob)
        
        base.position = [0, -0.4, 0]
        baseEntity = base
        entity.addChild(base)
    }
    
    private var rotationGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let deltaX = Float(value.translation.width - lastDragValue)
                entity.orientation *= simd_quatf(angle: deltaX * 0.002, axis: [0, 1, 0])
                lastDragValue = value.translation.width
            }
            .onEnded { _ in
                lastDragValue = 0
            }
    }
}

extension View {
    /// Adds a transparent hover base and enables single-handed rotation for a 3D entity.
    func hoverRotatable(for entity: Entity) -> some View {
        modifier(HoverRotateModifier(entity: entity))
    }
}
