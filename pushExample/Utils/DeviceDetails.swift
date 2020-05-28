//
//  DeviceDetails.swift
//  pushExample
//
//  Created by Alok Kulkarni on 15/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import Foundation
import UIKit
import DeviceCheck

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") {identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

class DeviceDetails: NSObject {
    
    
    static let sharedInstance = DeviceDetails()
    
    func getDeviceDetails() -> Dictionary<AnyHashable, Any> {
        var deviceDetials = Dictionary<AnyHashable, Any>.init()
        let device = DCDevice.current
        
        print("Supported Device \(device.isSupported)")
        
        if !device.isSupported
        {
            device.generateToken(completionHandler: { (data, error) in
                if let tokenData = data
                {
                    print("Received token \(tokenData)")
                    deviceDetials.updateValue(tokenData, forKey: "deviceToken")
                }
                else
                {
                    print("Hit error: \(error!.localizedDescription)")
                }
            })
        }
        
        deviceDetials.updateValue(UIDevice.current.identifierForVendor ?? UUID.init(), forKey: "vendorID")
        deviceDetials.updateValue(UIDevice.current.modelName, forKey: "model")
//        deviceDetials.updateValue(UIDevice.current.model, forKey: "model")
        deviceDetials.updateValue(UIDevice.current.name, forKey: "deviceName")
        deviceDetials.updateValue(UIDevice.current.systemName, forKey: "os")
        deviceDetials.updateValue(UIDevice.current.systemVersion, forKey: "osVersion")
        deviceDetials.updateValue(UUID.init(), forKey: "aid")
        deviceDetials.updateValue(NSLocale.autoupdatingCurrent.languageCode!, forKey: "languageCode")
        deviceDetials.updateValue(NSLocale.autoupdatingCurrent.usesMetricSystem, forKey: "metricSystem")
        deviceDetials.updateValue(DCDevice.current, forKey: "CurrentDevice")
        
        return deviceDetials
    }
    
    
}


/**
 * Instantiates a new Device details.
 * @param customerId
 * @param aid
 * @param deviceToken
 * @param deviceName
 * @param deviceOS
 * @param deviceBundleIdentifier
 * @param deviceType
 * @param deviceSerialNumber
 * @param deviceIMEINumber
 * @param devicedeploymentTarget
 * @param deviceApplicationVersion
 * @param deviceBuild
 * @param status
 * @param isMaster
 */
