//
//  TestViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 14/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet var resultImageview: UIImageView!
    @IBOutlet var paintableImageView: UIPaintableImageView!
    
    @IBAction func erease(_ sender: Any) {
        self.paintableImageView.paintView.lineColor = UIColor.clear
    }
    
    @IBAction func red(_ sender: Any) {
        self.paintableImageView.paintView.lineColor = UIColor.red
    }
    
    @IBAction func ok(_ sender: Any) {
        self.resultImageview.image = self.paintableImageView.resultImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
