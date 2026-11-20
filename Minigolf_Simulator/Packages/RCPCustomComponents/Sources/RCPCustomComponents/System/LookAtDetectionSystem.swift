//
//  LookAtDetectionSystem.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//

import OSLog
import Combine
import RealityKit

@MainActor
public struct LookAtDetectionSystem: System {
    
    public static let query = EntityQuery(where: .has(LookAtDetectionComponent.self))
    
    private var subscriptions = [Cancellable]()

    public init(scene: RealityKit.Scene) {
        subscriptions.append(scene.subscribe(to: ComponentEvents.DidAdd.self, componentType: LookAtDetectionComponent.self, { event in

        }))
    }
    
    public func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) where entity.isEnabled {
            guard var lookAtDetectionComponent = entity.lookAtDetectionComponent,
                  let lookAtDetectionRuntimeComponent = entity.lookAtDetectionRuntimeComponent else {
                continue
            }
            
            defer {
                entity.lookAtDetectionComponent = lookAtDetectionComponent
                entity.lookAtDetectionRuntimeComponent = lookAtDetectionRuntimeComponent
            }
            
            let targetPosition = lookAtDetectionRuntimeComponent.target.position(relativeTo: nil)
            let objectPosition = entity.position(relativeTo: nil)
            let lookDirection = entity.transformMatrix(relativeTo: nil).forward
            let objectToTargetPosition = normalize(targetPosition - objectPosition)
            let lookness = dot(objectToTargetPosition, lookDirection)
            let preciseness = lookAtDetectionComponent.preciseness
                        
            lookAtDetectionComponent.isTriggered = lookness >= preciseness
        }
    }
}
