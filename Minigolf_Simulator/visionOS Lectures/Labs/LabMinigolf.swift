//  visionOS Lectures - Labs
//
//  Title: Minigolf
//
//  Subtitle: Mixed-Reality Minigolf
//
//  Description: Am Immersive-Space-Ursprung platzierte Test-Entity mit Drag-Interaktion als Basis für den Hebel.
//
//  Type: Mixed Immersive Space
//

import RealityKit
import SwiftUI

struct LabMinigolf: View {

    @State private var testLever = Entity()
    @State private var leverAngle: Float = 0
    @State private var lastDragHeight: CGFloat = 0

    var body: some View {
        RealityView { content in
            // Der Immersive Space startet am Nutzerursprung (Blickrichtung -Z).
            // Eine Entity bei [0, -0.15, -1.2] liegt damit ~1,2 m vor dem Spieler.
            // Diese Root wird später zum gemeinsamen setupRoot für alle Spielelemente.
            let setupRoot = Entity()
            setupRoot.name = "minigolfSetupRoot"

            // Phase 0/1: einfache Test-Entity, später durch LeverEntity ersetzt.
            let lever = ModelEntity(
                mesh: .generateBox(size: SIMD3<Float>(0.08, 0.25, 0.08)),
                materials: [SimpleMaterial(color: .systemGreen, isMetallic: false)]
            )
            lever.name = "leverTest"
            lever.position = [0, -0.15, -1.2]
            lever.generateCollisionShapes(recursive: false)
            lever.components.set(InputTargetComponent())
            lever.components.set(HoverEffectComponent())

            setupRoot.addChild(lever)
            content.add(setupRoot)
            testLever = lever
        }
        .gesture(dragGesture)
        .ornament(attachmentAnchor: .scene(.bottomFront)) {
            VStack {
                Text("Minigolf – Drag-Test")
                    .font(.title3)
                Text("Winkel: \(Int(leverAngle * 180 / .pi))° / 60°")
                    .font(.caption)
            }
            .padding()
            .glassBackgroundEffect()
        }
    }

    /// Handbasierter Drag auf dem Gerät, Maus-/Trackpad-Drag im Simulator.
    /// Bewegt den Test-Hebel um die X-Achse im Bereich 0°–60°.
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = Float(value.translation.height - lastDragHeight)
                lastDragHeight = value.translation.height

                let maxAngle: Float = .pi / 3 // 60°
                leverAngle = min(max(leverAngle + delta * 0.01, 0), maxAngle)
                testLever.orientation = simd_quatf(angle: leverAngle, axis: [1, 0, 0])
            }
            .onEnded { _ in
                lastDragHeight = 0
            }
    }
}

#Preview(windowStyle: .volumetric) {
    LabMinigolf()
}
