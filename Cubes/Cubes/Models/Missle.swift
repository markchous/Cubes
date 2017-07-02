//
//  Missle.swift
//  Cubes
//
//  Created by Mark Houston on 7/2/17.
//  Copyright © 2017 Mark Houston. All rights reserved.
//

import Foundation
import SceneKit

class Missle: SCNNode {
    override init () {
        super.init()
        let sphere = SCNSphere(radius: 0.025)
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        // see http://texnotes.me/post/5/ for details on collisions and bit masks
        self.physicsBody?.categoryBitMask = PhysicsCategories.missle.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategories.cube.rawValue
        
        // add texture
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "missle")
        self.geometry?.materials  = [material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
