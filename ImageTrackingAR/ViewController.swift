//
//  ViewController.swift
//  ImageTrackingAR
//
//  Created by Chidi Emeh on 12/1/18.
//  Copyright © 2018 Chidi Emeh. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var frame: ARFrame?
    var camera: ARCamera?
    
    var skDelegate: ARSKViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/orange.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let arImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.trackingImages = arImage

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        
        //Container
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else { return }
        container.removeFromParentNode()
        node.addChildNode(container)
        container.isHidden = false
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.8)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
        }
        
        return node
    }
    
    /*
     OUTPUT: 1 frame (from 60fps)
     Frame: <ARFrame: 0x104666950 timestamp=2242215.553882 capturedImage=0x2812d7660 camera=0x281adb640 lightEstimate=0x2823906a0 | 1 anchor, 0 features>
     Node: <SCNNode: 0x281fc8a00 pos(0.225452 -0.673895 -0.110863) rot(0.640850 -0.766518 0.042000 0.259407) scale(1.000000 1.000000 1.000000) | 2 children>
     Anchor: <ARImageAnchor: 0x2814dc000 identifier="431A087A-B960-4843-9916-B998F5649248" transform=<translation=(0.225452 -0.673895 -0.110863) rotation=(9.52° -11.45° -0.33°)> referenceImage=<ARReferenceImage: 0x2800c6620 name="ace-skull" physicalSize=(0.102, 0.156)> tracked=NO>
     Camera: <ARCamera: 0x281adb640 imageResolution=(1920, 1080) focalLength=(1660.161, 1660.161) principalPoint=(959.500, 539.500) trackingState=Normal transform=<translation=(0.000000 0.000000 0.000000) rotation=(-63.58° -57.60° -100.35°)>>
     */
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let frame = self.sceneView.session.currentFrame else { return }
        print("Frame: \(frame)")
        print("Node: \(node)")
        print("Anchor: \(anchor)")
        print("Camera: \(frame.camera)")
    }
}

