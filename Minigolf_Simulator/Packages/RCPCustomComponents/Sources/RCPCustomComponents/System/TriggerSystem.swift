//
//  TriggerSystem.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//

import OSLog
import RealityKit

@MainActor
public struct TriggerSystem: System {
    
    public static let query = EntityQuery(where: .has(TriggerComponent.self))
    
    public init(scene: RealityKit.Scene) {}
    
    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) where entity.isEnabled {
            guard var triggerComponent = entity.triggerComponent,
                  let triggerRuntimeComponent = entity.triggerRuntimeComponent else {
                continue
            }
            
            defer {
                entity.triggerComponent = triggerComponent
                entity.triggerRuntimeComponent = triggerRuntimeComponent
            }
            
            let distance = distance(triggerRuntimeComponent.target.position, entity.position)
            let radius = triggerComponent.radius
            
            triggerComponent.isTriggered = distance <= radius
        }
    }
}
