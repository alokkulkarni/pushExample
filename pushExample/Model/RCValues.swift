//
//  RCValues.swift
//  pushExample
//
//  Created by Alok Kulkarni on 09/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import Foundation

enum RCKey : String {
    case homeLabel
    case nameLabel
}

class RCValues {
    
    let sharedInstance = RCValues()
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete: Bool = false
    
    private init() {
        loadDefaultValues()
    }
    
    
    func loadDefaultValues() {
        RCKey.homeLabel.rawValue : NSLocalizedString("Home", comment: "Home Label")
        RCKey.nameLabel.rawValue : NSLocalizedString("Name", comment: "Name Label")
    }
}

