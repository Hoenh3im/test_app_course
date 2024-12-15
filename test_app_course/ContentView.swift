import SwiftUI
import RealityKit

struct ContentView: View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Create a sphere model
        let sphere = MeshResource.generateSphere(radius: 0.1) // Sphere with a radius of 10 cm

        // Create a material with 50% opacity
        let material = SimpleMaterial(
            color: .init(Color.red.opacity(0.5)), // Gray with 50% opacity
            roughness: 0.15,
            isMetallic: false
        )
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])

        // Add the sphere to an anchor
        let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, -0.5)) // Place it 50 cm in front of the user
        anchor.addChild(sphereEntity)

        // Add the anchor to the AR scene
        arView.scene.anchors.append(anchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

#Preview {
    ContentView()
}
