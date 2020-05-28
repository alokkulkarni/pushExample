//
//  PricingAViewController.swift
//  pushExample
//
//  Created by Alok Kulkarni on 08/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import UIKit

class PricingAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pricing A"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
