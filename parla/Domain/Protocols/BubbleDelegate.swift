//
//  BubbleDelegate.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 01/02/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

protocol BubbleDelegate {
    
    func didTapMessageBubble(at indexPath: IndexPath, collectionView: UICollectionView)
    func didPressSendButton(withMessage message: SMessage, textField: UITextField, collectionView: UICollectionView)
    func didPresAccessoryButton(button: UIButton, collectionView: UICollectionView)
    
}
