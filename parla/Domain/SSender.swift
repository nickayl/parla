//
//  SSender.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 18/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

class SSender: NSObject {
    
    public var id: String
    public var name: String
    public var avatarImage: UIImage?
    
    init(senderId: String, senderName: String, avatarImage: UIImage?) {
        self.id = senderId
        self.name = senderName
        self.avatarImage = avatarImage
    }
    
}
