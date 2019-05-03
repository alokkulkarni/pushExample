//
//  Configs.swift
//  pushExample
//
//  Created by Alok Kulkarni on 01/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import Foundation
import SwiftyJSON

class Config {
    
    let configID: String
    let configSentDate : String
    let expiration : String
    let status : String
    let category : String
    let isPopUp : Bool
    let isConditional : Bool
    let conditionParam : String
    let customParams : [String: Any]
    
    
    init(json: JSON) {
        self.configID = json["id"].stringValue
        self.configSentDate = json["configSentDate"].stringValue
        self.category = json["category"].stringValue
        self.status = json["status"].stringValue
        self.expiration = json["expiration"].stringValue
        self.isPopUp = json["popup"].boolValue
        self.isConditional = json["conditional"].boolValue
        self.conditionParam = json["conditionParam"].stringValue
        self.customParams = JSON.init(parseJSON: json["configParams"].stringValue).dictionaryObject!
    }
}



