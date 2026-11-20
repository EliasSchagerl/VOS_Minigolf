//
//  DrawSystem.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//

import OSLog
import Combine
import RealityKit

@MainActor
public struct DrawSystem: System {
    
    public static let query = EntityQuery(where: .has(DrawComponent.self))
    
    private var subscriptions = [Cancellable]()
        
    public init(scene: RealityKit.Scene) {
        subscriptions.append(scene.subscribe(to: ComponentEvents.DidAdd.self, componentType: DrawComponent.self, { event in
            if let drawComponent = event.entity.drawComponent {
                if event.entity.drawRuntimeComponent == nil {
                    event.entity.components.set(DrawRuntimeComponent())
                }
                
                if drawComponent.showAxes && event.entity.drawRuntimeComponent?.axes == nil {
                    event.entity.addAxes()
                }
            }
        }))
    }
    
    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) where entity.isEnabled {
            guard let drawComponent = entity.drawComponent,
                  let drawRuntimeComponent = entity.drawRuntimeComponent else {
                continue
            }
            
            defer {
                entity.drawComponent = drawComponent
                entity.drawRuntimeComponent = drawRuntimeComponent
            }
            
            handleAxes(drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
            handleCones(entity: entity, drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
            handleLines(entity: entity, drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
            handleSpheres(entity: entity, drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
            handleVectors(entity: entity, drawComponent: drawComponent, drawRuntimeComponent: drawRuntimeComponent)
        }
    }
    
    func handleAxes(drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        if let axes = drawRuntimeComponent.axes {
            if drawComponent.showAxes && !axes.isEnabled {
                drawRuntimeComponent.axes?.isEnabled = true
            } else if !drawComponent.showAxes && axes.isEnabled {
                drawRuntimeComponent.axes?.isEnabled = false
            }
        }
    }
    
    func handleCones(entity: Entity, drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        for var cone in drawRuntimeComponent.cones {
            cone.visualEntity?.isEnabled = cone.isEnabled
            
            if cone.isEnabled {
                // There is currently a bug that moves a Volumes world space origin to
                // the back of the volume after the RealityView initialization (FB20853721)
                // Therefore, we position the cone relative to the root entity
                let root = entity.scene?.findEntity(named: Constants.mainRoot) ?? nil
                
                if let target = cone.target {
                    if cone.lookAtTarget {
                        cone.visualEntity?.look(at: target.position, from: entity.position, relativeTo: entity.parent)
                        cone.visualEntity?.orientation *= simd_quatf(angle: .pi / 2, axis: [1, 0, 0])
                        // * 1 / cone.height since the height also changes the y-scale
                        cone.visualEntity?.setPosition([0, -((cone.height / 2) * 1 / cone.height), 0], relativeTo: cone.visualEntity!)
                    } else {
                        cone.position = target.position(relativeTo: root)
                    }
                } else {
                    cone.visualEntity?.setPosition(cone.position, relativeTo: root)
                }
                
                cone.visualEntity?.scale.x = cone.radius
                cone.visualEntity?.scale.y = cone.height
                cone.visualEntity?.scale.z = cone.radius

                if var material = cone.visualEntity?.modelComponent?.materials.first as? UnlitMaterial, material.color.tint != cone.color  {
                    material.color.tint = cone.color
                    cone.visualEntity?.modelComponent?.materials = [material]
                }
            }
        }
    }

    func handleLines(entity: Entity, drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        for var line in drawRuntimeComponent.lines {
            line.visualEntity?.isEnabled = line.isEnabled
            
            if line.isEnabled {
                if let startTarget = line.startTarget {
                    line.start = startTarget.position(relativeTo: nil)
                }
                
                if let endTarget = line.endTarget {
                    line.end = endTarget.position(relativeTo: nil)
                }
                
                let vector = line.end - line.start
                let length = length(vector)
                line.visualEntity?.scale.z = length
                line.visualEntity?.look(at: line.end, from: line.start + (vector / 2), relativeTo: entity.parent)

                if var material = line.visualEntity?.modelComponent?.materials.first as? UnlitMaterial, material.color.tint != line.color {
                    material.color.tint = line.color
                    line.visualEntity?.modelComponent?.materials = [material]
                }
            }
        }
    }
    
    func handleSpheres(entity: Entity, drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        for var sphere in drawRuntimeComponent.spheres {
            sphere.visualEntity?.isEnabled = sphere.isEnabled
            
            if sphere.isEnabled {
                if let target = sphere.target {
                    sphere.position = target.position(relativeTo: nil)
                }
                
                sphere.visualEntity?.setPosition(sphere.position, relativeTo: nil)
                sphere.visualEntity?.scale = .init(repeating: sphere.radius)

                if var material = sphere.visualEntity?.modelComponent?.materials.first as? UnlitMaterial, material.color.tint != sphere.color  {
                    material.color.tint = sphere.color
                    sphere.visualEntity?.modelComponent?.materials = [material]
                }
            }
        }
    }
    
    func handleVectors(entity: Entity, drawComponent: DrawComponent, drawRuntimeComponent: DrawRuntimeComponent) {
        for var vector in drawRuntimeComponent.vectors {
            vector.visualEntity?.isEnabled = vector.isEnabled
            
            if vector.isEnabled {
                let root = entity.scene?.findEntity(named: Constants.mainRoot) ?? nil

                if let startTarget = vector.startTarget {
                    vector.start = startTarget.position(relativeTo: nil)
                }
                
                if let endTarget = vector.endTarget {
                    vector.end = endTarget.position(relativeTo: nil)
                }
                
                let startToEndVector = vector.end - vector.start
                let length = length(startToEndVector)
                
                let shaft = vector.visualEntity?.children.first(where: { $0.name == Constants.shaft })
                shaft?.scale.z = length - 0.025 // Subtract the hardcoded end height for the correct length of the shaft
                shaft?.position.z = -length / 2 + 0.0125 // Offset half of hardcoded end height to place the shaft correctly between the origin and the end
                
                let end = vector.visualEntity?.children.first(where: { $0.name == Constants.end })
                end?.position.z = -length + 0.0125 // Offset half of hardcoded end height that the top of the end points at the vector end
                
                vector.visualEntity?.look(at: vector.end, from: vector.start, relativeTo: root)
                
                vector.visualEntity?.forEachDescendant(withComponent: ModelComponent.self) { entity, _ in
                    if var material = entity.modelComponent?.materials.first as? UnlitMaterial, material.color.tint != vector.color {
                        material.color.tint = vector.color
                        entity.modelComponent?.materials = [material]
                    }
                }
            }
        }
    }
}
