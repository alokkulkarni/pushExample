//
//  CrossfadeSegue.swift
//  pushExample
//
//  Created by Alok Kulkarni on 01/09/2018.
//  Copyright © 2018 Alok Kulkarni. All rights reserved.
//

import UIKit

class CrossfadeSegue: UIStoryboardSegue {
    
    override func perform() {
        let secondVCView = destination.view
        secondVCView?.alpha = 0.0
        source.present(destination, animated: true, completion: nil)
//        source.navigationController?.pushViewController(destination, animated: false)
        UIView.animate(withDuration: 0.4) {
            secondVCView?.alpha = 1.0
        }
    }
    
}
