//
//  RCPCustomComponents
//  visionOS27_RCP3_Template
//
//  Created by Tempuno e.U. on 03.11.26.
//

import RealityKit
import RealityComposerPro
import OSLog

#if os(macOS)
import AppKit
public typealias UIColor = NSColor
#endif

let logger = Logger(subsystem: "com.tempuno.visionOS-Lectures", category: "module")

/// A custom component package for Reality Composer Pro.
///
/// This class registers custom RealityKit components and systems for use in
/// Reality Composer Pro projects. Add your custom component and system registrations
/// in the ``setup(context:)`` method.
final class RCPCustomComponentPlugin: RealityComposerProPlugin {

    /// Registers custom components and systems with Reality Composer Pro.
    ///
    /// Implement this method to register your custom components and systems.
    /// This method is called when the framework is loaded.
    ///
    /// - Parameter context: The Reality Composer Pro context for registration.
    func setup(context: RealityComposerProContext) {
        // Register your custom components here
        context.registerComponent(SampleSpinComponent.self)
        context.registerComponent(DrawComponent.self)
        context.registerComponent(LookAtDetectionComponent.self)
        context.registerComponent(TriggerComponent.self)

        // Register your custom systems here
        context.registerSystem(SampleSpinSystem.self)
        context.registerSystem(DrawSystem.self)
        context.registerSystem(LookAtDetectionSystem.self)
        context.registerSystem(TriggerSystem.self)

        // Register your custom actions here
        context.registerAction(SampleBounceAction.self)

        // Add any extra setup below.

        // Subscribes directly to update, without a handler object.
        SampleBounceAction.subscribe()
    }
}

/// The C-compatible entry point for loading the custom components.
///
/// This function is called by Reality Composer Pro to create an instance of the
/// custom components. Do not call this function directly.
///
/// - Returns: An opaque pointer to the custom components instance.
@_cdecl("createRealityComposerProPlugin")
public func createRealityComposerProPlugin() -> UnsafeMutableRawPointer {
    RCPCustomComponentPlugin().passRetained()
}
