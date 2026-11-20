//
//  LookAtDetectionComponent.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 20.10.25.
//

import Foundation
import RealityKit

public struct LookAtDetectionComponent: Component, Codable {
    public var preciseness: Float = .zero
    public var isTriggered: Bool = false
    
    public init(preciseness: Float, isTriggered: Bool = false) {
        self.preciseness = preciseness
        self.isTriggered = isTriggered
    }
}

public struct LookAtDetectionRuntimeComponent: Component {
    public var target: Entity

    public init(target: Entity) {
        self.target = target
    }
}
