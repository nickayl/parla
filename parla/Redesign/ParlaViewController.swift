//
//  ParlaViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

protocol ParlaDataSource {
    var sender: PSender! { get set }
    
   // func bubbleViewForItem(at indexPath: IndexPath) -> AbstractMessageCell
    func messageForBubbble(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int
}

protocol ParlaDelegate {
    
    func didTapMessageBubble(at indexPath: IndexPath, collectionView: UICollectionView)
    func didPressSendButton(withMessage message: PMessage, textField: UITextField, collectionView: UICollectionView)
    func didPresAccessoryButton(button: UIButton, collectionView: UICollectionView)
    
}

class ParlaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var parlaSender: PSender!
    var parlaDataSource: ParlaDataSource!
    var parlaDelegate: ParlaDelegate?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = parlaDataSource.messageForBubbble(at: indexPath, collectionView: collectionView)
        
        if var imageMessage = message as? PImageMessage {
            imageMessage.viewController = self
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: message.cellIdentifier, for: indexPath) as! AbstractMessageCell
        
        cell.viewController = self
        cell.indexPath = indexPath
        
        return cell
        
        
        
        
      //  var cellIdentifier: String
        
//        let type = message.messageType
//        let senderType = message.senderType
//
//        // Text message
//        if type == .TextMessage && senderType == .Incoming {
//            //cellIdentifier = "BubbleCellViewIDTextIncoming"
//            cellIdentifier = incomingTextMessageReuseIdentifier
//        }
//        else if type == .TextMessage && senderType == .Outgoing {
//            cellIdentifier = outgoingTextMessageReuseIdentifier
//        }
//            // ----
//
//            // Image and Video message
//        else if (type == .ImageMessage || type == .VideoMessage) && senderType == .Outgoing {
//            cellIdentifier = incomingImageMessageReuseIdentifier
//        }
//        else if (type == .ImageMessage || type == .VideoMessage) && senderType == .Incoming {
//            cellIdentifier = outgoingImageMessageReuseIdentifier
//        }
//            // ---
//
//            // Voice message
//        else if type == .VoiceMessage  && senderType == .Incoming {
//            cellIdentifier = incomingVoiceMessageReuseIdenfitier
//        }
//        else  {
//            cellIdentifier = "BubbleCellViewIDVoiceOutgoing"
//        }
//        // ---

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (collectionView.cellForItem(at: indexPath) as! AbstractMessageCell).getSize()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parlaDataSource.numberOfMessagesIn(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Parla.config.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Parla.config.sectionInsets
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
