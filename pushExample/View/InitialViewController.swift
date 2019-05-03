//
//  InitialViewController.swift
//  pushExample
//
//  Created by Alok Kulkarni on 01/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    


    @IBOutlet var lblLoading: UILabel!
    var fetchResult : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDeviceDetials(deviceDetials: DeviceDetails.sharedInstance.getDeviceDetails())
        
        RemoteConfig.sharedInstance.fetchRemoteConfig { (result) in
            self.fetchResult = result!
            if self.fetchResult {
                self.startAppForReal()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func startAppForReal() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loadingDoneSegue", sender: self)
        }
    }
    
    func updateDeviceDetials(deviceDetials : Dictionary<AnyHashable, Any>) {
        print(deviceDetials)
    }
}
