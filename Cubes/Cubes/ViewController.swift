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
    
    // MARK: - IBOutlets
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var scoreLabel: UILabel!
    
    var score = 0
    
    // MARK: - Overrides
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        configureUI()
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
    
    // MARK: - ConfigureUI
    
    private func configureUI() {
        let selfTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScreen(_:)))
        view.addGestureRecognizer(selfTapGesture)
    }
    
    // MARK: - Gesture Handler(s)
    
    @objc private func didTapScreen(_ gesture: UITapGestureRecognizer) {
        print("didTapScreen")
        shootMissle()
    }
    
    // MARK: - Place cube
    
    private func placeCube() {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(getRanFloat(), getRanFloat(), -1.0)
        let shape = SCNPhysicsShape(geometry: box, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        node.physicsBody?.isAffectedByGravity = false
        node.physicsBody?.categoryBitMask = PhysicsCategories.cube.rawValue
        node.physicsBody?.contactTestBitMask = PhysicsCategories.missle.rawValue
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    // MARK: - Shoot missle
    
    private func shootMissle() {
        let (direction, position) = getUserVector()
        let missle = Missle()
        missle.position = position
        missle.physicsBody?.applyForce(direction, asImpulse: true)
        
        sceneView.scene.rootNode.addChildNode(missle)
        print("shoot missle...")
    }
    
    // MARK: - Remove missle
    
    private func removeNode(node: SCNNode) {
        node.removeFromParentNode()
        print("Node removed from parent node")
    }
    
    // MARK: - Get user vector
    
    private func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    // MARK: - Get random float
    
    private func getRanFloat() -> Float {
        return Float(arc4random()) / Float(UINT32_MAX)
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
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("collision did begin")
        if contact.nodeA.physicsBody?.categoryBitMask == PhysicsCategories.cube.rawValue ||
            contact.nodeB.physicsBody?.categoryBitMask == PhysicsCategories.cube.rawValue {
            removeNode(node: contact.nodeA)
            removeNode(node: contact.nodeB)
            
            score += 1
            
            DispatchQueue.main.async(execute: {
                self.scoreLabel.text = "Score: \(self.score)"
            })
            
            placeCube()
        }
    }
    
}

