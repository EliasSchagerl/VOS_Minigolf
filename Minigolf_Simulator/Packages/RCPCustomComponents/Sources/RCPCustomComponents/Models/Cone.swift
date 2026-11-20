//
//  Cone.swift
//  RealityKitContent
//
//  Created by Tempuno e.U. on 23.10.25.
//

import RealityKit
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct Cone {
    public var id: UUID = UUID()
    public var height: Float = .zero
    public var radius: Float = .zero
    public var position: SIMD3<Float> = .zero
    public var target: Entity? = nil
    public var lookAtTarget: Bool = false
    public var color: UIColor = .white
    public var isEnabled: Bool = true
    
    public var visualEntity: Entity? = nil
    
    public init(
        id: UUID = UUID(),
        position: SIMD3<Float> = .zero,
        height: Float,
        radius: Float,
        target: Entity? = nil,
        lookAtTarget: Bool = false,
        color: UIColor = .white,
        isEnabled: Bool = true,
        visualEntity: Entity? = nil
    ) {
        self.id = id
        self.position = position
        self.height = height
        self.radius = radius
        self.target = target
        self.lookAtTarget = lookAtTarget
        self.color = color
        self.isEnabled = isEnabled
        self.visualEntity = visualEntity
    }
}
