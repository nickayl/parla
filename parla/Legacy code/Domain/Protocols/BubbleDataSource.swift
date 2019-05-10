//
//  BubbleDataSource.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 29/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

protocol BubbleDataSource {
    
    var sender: SSender! { get set }
    
    func bubbleViewForItem(at indexPath: IndexPath) -> CellBubble
    func messageForBubbble(at indexPath: IndexPath, collectionView: UICollectionView) -> SMessage
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int
    
}
