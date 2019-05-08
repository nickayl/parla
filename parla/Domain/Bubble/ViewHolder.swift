//
//  ViewHolder.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 18/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

protocol ViewHolder {
    
    associatedtype T
    
    func getView(rCell: UICollectionViewCell) -> T
    
}
