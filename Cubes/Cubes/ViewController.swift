//
//  ViewController.swift
//  Cubes
//
//  Created by Mark Houston on 7/1/17.
//  Copyright © 2017 Mark Houston. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Automatically adjust lighting
        sceneView.automaticallyUpdatesLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the physics body
        scene.physicsWorld.contactDelegate = self
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        
        // Place cube in the scene
        placeCube()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(self) received memory warning!")
    }
    
    // MARK: - Actions
    
    @IBAction func didTapScreen(_ sender: Any) {
        print("didTapScreen")
    }
    
    // MARK: - Place cube
    
    private func placeCube() {
        let node = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        node.position = SCNVector3(0, 0, -1.0) // SceneKit/AR coordinates are in meters
        sceneView.scene.rootNode.addChildNode(node)
    }
    
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
     }
    */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
}

// MARK: - SCNPhysicsContactDelegate

extension ViewController: SCNPhysicsContactDelegate {
    
    
    
}

