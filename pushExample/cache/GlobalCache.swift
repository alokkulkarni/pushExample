//
//  GlobalCache.swift
//  pushExample
//
//  Created by Alok Kulkarni on 04/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import Foundation

class GlobalCache {
    
    static let sharedCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "globalCache"
        cache.countLimit = 200 // Max 20 images in memory.
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
}
