//
//  RCSwift.swift
//  pushExample
//
//  Created by Alok Kulkarni on 31/08/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RCSwift {
    
    enum ValueKey: String {
        case bigLabelColor
        case appPrimaryColor
        case navBarBackground
        case navTintColor
        case detailTitleColor
        case detailInfoColor
        case subscribeBannerText
        case subscribeBannerButton
        case subscribeVCText
        case subscribeVCButton
        case shouldWeIncludePluto
        case experimentGroup
        case planetImageScaleFactor
    }
    
    
    static let sharedInstance = RCSwift()
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    
    static let baseURLPath = "http://localhost:8080/configs/"
    
//        321456897/configs/active
    
//        completion: @escaping ([String]?) -> Void
    
//    var method: HTTPMethod {
//        switch self {
//        case .updateStatus:
//            return .post
//        case .activeConfigs:
//            return .get
//        }
//    }
    
//    var path: String {
//        switch self {
//        case .activeConfigs:
//            return "/configs/active"
//        case .updateStatus:
//            return "/updateStatus?status=read"
//        }
//    }
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    func loadDefaultValues() {
        let _: [String: Any?] = [
            ValueKey.bigLabelColor.rawValue: "#FFFFFF66",
            ValueKey.appPrimaryColor.rawValue: "#FBB03B",
            ValueKey.navBarBackground.rawValue: "#535E66",
            ValueKey.navTintColor.rawValue: "#FBB03B",
            ValueKey.detailTitleColor.rawValue: "#FFFFFF",
            ValueKey.detailInfoColor.rawValue: "#CCCCCC",
            ValueKey.subscribeBannerText.rawValue: "Like Planet Tour?",
            ValueKey.subscribeBannerButton.rawValue: "Get our newsletter!",
            ValueKey.subscribeVCText.rawValue: "Want more astronomy facts? Sign up for our newsletter!",
            ValueKey.subscribeVCButton.rawValue: "Subscribe",
            ValueKey.shouldWeIncludePluto.rawValue: false,
            ValueKey.experimentGroup.rawValue: "default",
            ValueKey.planetImageScaleFactor.rawValue: 0.33
        ]
    }
    
    
}

