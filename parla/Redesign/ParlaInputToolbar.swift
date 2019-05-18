//
//  ParlaInputToolbar.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 18/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

public class ParlaInputToolbar: UIView {

    @IBOutlet var sendButton: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var microphoneButton: UIMicrophoneView!
    @IBOutlet var accessoryButton: UIView!
    
}

public class DefaultParlaInputToolbar : ParlaInputToolbar {
    
    public override func awakeFromNib() {
        self.textField.setBorderRadius(radius: 20)
        self.textField.layer.borderWidth = 1
        self.textField.layer.borderColor = UIColor(withRed: 0, green: 122, blue: 255).cgColor
        //  inputToolbarContainer?.subviews.filter { $0.tag == 69 }.first?.setBorderRadius(radius: 7)
        
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
    }
}
