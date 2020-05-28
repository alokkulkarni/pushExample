//
//  RemoteConfig.swift
//  pushExample
//
//  Created by Alok Kulkarni on 31/08/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import Foundation
import SwiftyJSON

class RemoteConfig {
    
    static let sharedInstance = RemoteConfig()
    
    enum RemoteConfigFetchStatus : String {
        /// Config has never been fetched.
        case RemoteConfigFetchStatusNoFetchYet
        /// Config fetch succeeded.
        case RemoteConfigFetchStatusSuccess
        /// Config fetch failed.
        case RemoteConfigFetchStatusFailure
        /// Config fetch was throttled.
        case RemoteConfigFetchStatusThrottled
    }
    
    
//    completion: @escaping ([String]?) -> Void
    func fetchRemoteConfig(completion: @escaping (Bool?) -> Void) {
        
        var _ : NSInteger = 0
        
        let cache = GlobalCache.sharedCache as! NSCache<NSString, Config>
        
        let url = URL(string: "https://998d915e.ngrok.io/configs/active")
        
        var _ : [[String : AnyObject]]? = nil
        
        cache.removeAllObjects()
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if ((data) != nil) {
                try! JSON.init(data: data!).array?.forEach({ (json) in
//                    print(json)
                    let configs = Config.init(json: json)
                    if (configs.status == "active") {
                        var cacheKey : String = " "
                        print(configs.isPopUp)
                        if (configs.isPopUp == true) {
                            cacheKey = configs.category + "true"
                        } else {
                            cacheKey = configs.category + "false"
                        }
                        print(cacheKey)
                        cache.setObject(configs, forKey: cacheKey as NSString)
//                        let cacheConfig = cache.object(forKey: configs.category as NSString)
//                        print(cacheConfig?.customParams["IMAGE"] as Any)
                    } else {
                        cache.removeAllObjects();
                        print("No configs available or is expired")
                    }
                })
                completion(true)
            } else if ((error) != nil) {
                completion(false)
            }
            
        }
        dataTask.resume()
    }
    
    func UpdateConfigStatus(UpdateConfig : Bool, configID : String) {
        let update_url = URL(string: "http://192.168.0.18:8080/configs/\(configID)/updateStatus?status=read")
        
        let dataTask = URLSession.shared.dataTask(with: update_url!) { (data, respo, error) in
            try! JSON.init(data: (data)!).array?.forEach({ (json) in
                print(json)
            })
        }
        dataTask.resume()
    }
    
//    let update_url = URL(string: "http://localhost:8080/configs/5b8aef9dea7b78daea58c9b8/updateStatus?status=read")
    
    
}
