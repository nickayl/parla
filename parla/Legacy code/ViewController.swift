//
//  ViewController.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 16/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import UIKit

class ViewController: ChatViewController {
    
    private var m: [SMessage] = []
    
    override func viewDidLoad() {
        self.sender = SSender(senderId: "0", senderName: "Domenico", avatarImage: UIImage(withBackground: UIColor.black))
        
        self.config.avatarIsHidden = false
        self.config.avatarBackgroundColor = UIColor.black
        self.config.cellBottomLabelHidden = false
        self.config.kDefaultImageBubbleSize = CGSize(width: 170, height: 150)
        
        self.m.append(contentsOf: DebuggingStuff.initChat())
        super.viewDidLoad()
//        self.collectionView.reloadData()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func messageForBubbble(at indexPath: IndexPath, collectionView: UICollectionView) -> SMessage {
        return m[indexPath.item]
    }
    
    override func numberOfMessagesIn(collectionView: UICollectionView) -> Int {
        return self.m.count
    }
    
    override func didPressSendButton(withMessage message: SMessage, textField: UITextField, collectionView: UICollectionView) {
        textField.text = ""
        
        self.m.append(message)
        
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
    
    override func didTapMessageBubble(at indexPath: IndexPath, collectionView: UICollectionView) {
        print("Bubble image selected!" )
        
        print("indexpath: \(indexPath.item)")
        print("Call the superclass implementation if you want to leave the default behaviour")
        super.didTapMessageBubble(at: indexPath, collectionView: collectionView)
    }

    

}

