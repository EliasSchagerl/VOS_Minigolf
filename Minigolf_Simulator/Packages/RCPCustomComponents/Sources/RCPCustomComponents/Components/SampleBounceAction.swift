//
//  RCPCustomComponents
//  visionOS27_RCP3_Template
//
//  Created by Tempuno e.U. on 03.11.26.
//

import RealityKit

/// Entity action used to animate an entity's transform so it animates up and down along Y.
///
/// This sample action animates an entity's vertical position using a sine wave to create
/// an undulating effect. The animation can be customized with height and frequency parameters.
///
/// Its animated value is processed by the animation manager, and will cross fade properly
/// with other animations targeting the same entity transform.
public struct SampleBounceAction: EntityAction, Codable {
    /// Whether the action can be reversed (played backwards).
    public var isReversible: Bool { true }

    /// Whether the action is additive (combines with other animations).
    public var isAdditive: Bool { false }

    /// The maximum height of the Y animation in meters.
    public var bounceHeight: Double

    /// The frequency of the Y animation in cycles per second.
    public var bounceFrequency: Double

    /// The type of value this action animates (Transform in this case).
    public var animatedValueType: (any AnimatableData.Type)? { Transform.self  }

    /// The action's identifier name.
    public static var actionName: String { "Sample BounceAction" }

    /// Creates a new AnimateY action with the specified parameters.
    ///
    /// - Parameters:
    ///   - bounceHeight: The maximum height of the Y animation in meters. Default is 0.5.
    ///   - bounceFrequency: The frequency of the Y animation in cycles per second. Default is 1.0.
    public init(bounceHeight: Double = 0.5, bounceFrequency: Double = 1.0) {
        self.bounceHeight = bounceHeight
        self.bounceFrequency = bounceFrequency
    }
           
    public static func subscribe()
    {
        Task { @MainActor in

            SampleBounceAction.subscribe(to: .updated) { event in

                if var currentTransform = event.animationState?.defaultSource as? Transform,
                   let normalizedTime = event.animationState?.normalizedTime {

                    // Compute vertical offset using a sine wave: amplitude * sin(π * t * frequency)
                    // This produces a smooth bounce that completes full cycles over the action's duration.
                    let offset = Float(event.action.bounceHeight * sin(.pi * normalizedTime * event.action.bounceFrequency))
                    currentTransform.translation.y += offset

                    event.animationState?.storeAnimatedValue(currentTransform)
                }
            }
        }
    }
}
