//
//  RCPCustomComponents
//  visionOS27_RCP3_Template
//
//  Created by Tempuno e.U. on 03.11.26.
//

import RealityKit

/// A component that continuously rotates an entity around a specified axis.
///
/// Attach this component to any entity to make it spin continuously. The rotation
/// speed and axis can be customized through the component's properties.
///
/// For more information about implementing custom systems, see
/// [Implementing systems for entities in a scene](https://developer.apple.com/documentation/realitykit/implementing-systems-for-entities-in-a-scene).
public struct SampleSpinComponent: Component, Codable {
    
    /// Whether the spinning behavior is enabled.
    ///
    /// Set to `false` to temporarily pause the spinning without removing the component.
    public var isEnabled: Bool
    
    /// The rotation speed in radians per second.
    ///
    /// Positive values rotate in one direction, negative values rotate in the opposite direction.
    public var speed: Float
    
    /// The axis of rotation in local space.
    public var axis = SIMD3<Float>(0,1,0)

    /// The component's identifier name.
    public static var componentName: String { "Sample SpinComponent" }
}

/// A system that updates entities with the ``SampleSpinComponent``.
///
/// This system automatically rotates all entities that have a ``SampleSpinComponent``
/// attached. The rotation is applied every frame based on the component's speed and axis settings.
public struct SampleSpinSystem: System {
    /// The query for finding entities with the spin component.
    static let query = EntityQuery(where: .has(SampleSpinComponent.self))

    /// Creates a new spin system instance.
    ///
    /// - Parameter scene: The RealityKit scene this system belongs to.
    public init(scene: RealityKit.Scene) { }

    /// Updates all entities with spin components.
    ///
    /// This method is called every frame to rotate entities based on their
    /// spin component settings and the elapsed time since the last update.
    ///
    /// - Parameter context: The scene update context containing timing and entity information.
    public func update(context: SceneUpdateContext) {
        let queryResult = context.entities(matching: Self.query, updatingSystemWhen: .rendering)
        for entity in queryResult {
            if let component = entity.components[SampleSpinComponent.self], component.isEnabled {
                entity.orientation *= simd_quatf(angle: Float(context.deltaTime) * component.speed, axis: component.axis)
            }
        }
    }
}
