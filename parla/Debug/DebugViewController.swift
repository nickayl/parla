//
//  DebugViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 04/06/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Parla.preloadAsynch(withFrame: view.frame)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
