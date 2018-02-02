//
//  PhycisCategories.swift
//  Cubes
//
//  Created by Mark Houston on 7/1/17.
//  Copyright © 2017 Mark Houston. All rights reserved.
//

import Foundation

struct PhysicsCategories {
    let rawValue: Int
    
    static let missle  = PhysicsCategories(rawValue: 1 << 0) // 00...01
    static let cube = PhysicsCategories(rawValue: 1 << 1) // 00..10
}
