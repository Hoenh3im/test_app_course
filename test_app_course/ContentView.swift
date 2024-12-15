import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Enable AR session for raycasting
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal] // Detect horizontal surfaces
        arView.session.run(config)

        // Add a tap gesture recognizer for raycasting
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            let tapLocation = gesture.location(in: arView)

            // Perform a raycast to find a horizontal surface
            if let result = arView.raycast(from: tapLocation, allowing: .existingPlaneGeometry, alignment: .horizontal).first {
                // Create a sphere model
                let sphere = MeshResource.generateSphere(radius: 0.1)
                let material = SimpleMaterial(color: .red, roughness: 0.15, isMetallic: true)
                let sphereEntity = ModelEntity(mesh: sphere, materials: [material])

                // Enable gesture interactions for the sphere
                sphereEntity.generateCollisionShapes(recursive: true)
                arView.installGestures([.rotation, .scale, .translation], for: sphereEntity)

                // Place the sphere at the raycast result position
                sphereEntity.position = SIMD3(result.worldTransform.translation)

                // Add the sphere to an anchor and the AR scene
                let anchor = AnchorEntity(world: result.worldTransform.translation)
                anchor.addChild(sphereEntity)
                arView.scene.anchors.append(anchor)
            }
        }
    }
}

extension simd_float4x4 {
    var translation: SIMD3<Float> {
        return SIMD3(x: columns.3.x, y: columns.3.y, z: columns.3.z)
    }
}
