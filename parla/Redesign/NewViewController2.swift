//
//  NewViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit
import CoreLocation

class NewViewController2 : UIViewController, ParlaViewDataSource, ParlaViewDelegate, CLLocationManagerDelegate  {
    
    private var collectionView: UICollectionView!
    
    // The main sender. His messages are considered as Outgoing, all the messages of other senders will be considerer as Incoming messages.
    var mainSender: POutgoingSender!
    
    // The array of messages
    var messages: [PMessage]!
    
    // The core of the library: The ParlaView class
    @IBOutlet var parlaView: ParlaView!
    
    override func viewDidLoad() {
        
       
        // The avatars of the senders. If you do not want an avatar pass nil and disable avatar in the config
        // class before initializing: Parla.config.avatar.isHidden = true
        let domenicoAvatar = PAvatar(withImage: UIImage(named: "domenico.jpeg")!)
        let chiaraAvatar = PAvatar(withImage: UIImage(named: "chiara.jpg")!)
        
        // In this example we have 2 message senders
        mainSender = Parla.outgoingSender(id: 10, name: "Domenico", avatar: domenicoAvatar)
        let chiara = PIncomingSender(id: 11, name: "Chiara", avatar: chiaraAvatar)
        
        let config = Parla.config
        config.accessoryButton.preventDefault = false
        config.cell.isBottomLabelHidden = false
        config.avatar.isHidden = false
        
        // This color will be used if you pass a nil avatar to a sender but do not set the isHidden property to true.
        config.avatar.backgroundColor = UIColor.black
        
        // Initialization of ParlaView class
        parlaView.initialize(dataSource: self, delegate: self)
        
        // This is a test video taken from the main bundle.
        let mondello = Bundle.main.url(forResource: "mondello", withExtension: "mp4")!
        
        // Adding some test messages
        self.messages = [
            Parla.newTextMessage(id: 1, sender: mainSender, text: "Hi Chiara! How are you? :)"),
            Parla.newTextMessage(id: 2, sender: chiara, text: "Hi Domenico, all right! I'm sitting on a deckchiar here in the wonderful beach of Mondello, in Palermo (Italy)  :)"),
            Parla.newTextMessage(id: 3, sender: mainSender, text: "Waw! Tha's awesome! I can't wait to see a picture of you in this wonderful place!"),
            Parla.newImageMessage(id: 4, sender: chiara, image: UIImage(named: "mondello-beach.jpg")!),
            Parla.newVideoMessage(id: 5, sender: chiara, videoUrl: mondello),
            Parla.newTextMessage(id: 6, sender: mainSender, text: "Amazing, i'm coming right now!"),
        ]
        
       
        // Hide the top label every 4 times.
        for i in 0 ..< messages.count {
            messages[i].isTopLabelActive = (i % 4 == 0)
            // messages[i].isTopLabelActive = false
        }
        
        
        self.collectionView = parlaView.collectionView
    }
    
    
    func didTapMessageBubble(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView) {
        message.triggerSelection()
        print("===>> DID TAP MESSAGE BUBBLE \(message.toString) << ===")
        
    }
    
    func didLongTouchMessage(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView) {
        print("===>> DID LONG TOUCH MESSAGE BUBBLE: \(message.toString) << ===")
    }
    
    func didFinishBuildingCurrentLocationMessage(with coordinates: CLLocationCoordinate2D, with message: PMapMessage) {
        print("END building current location message")
        
    }
    
    func didStartBuildingCurrentLocationMessage(with coordinates: CLLocationCoordinate2D, with message: PMapMessage) {
        print("START building current location message")
        self.messages.append(message)
        self.parlaView.refreshCollection(animated: true)
    }
    
    func didPressSendButton(withMessage message: PMessage, textField: UITextField, collectionView: UICollectionView) {
        self.messages.append(message)
        textField.text = ""
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
    
    func didStartPickingImage(collectionView: UICollectionView) {
        print("Starting picking image...")
    }
    
    func didFinishPickingVideo(with: URL?, collectionView: UICollectionView) {
        if let url = with {
            let msg = PVideoMessageImpl(id: messages.count+1, sender: outgoingSender(), videoUrl: url)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    func didFinishPickingImage(with image: UIImage?, collectionView: UICollectionView) {
        if image != nil {
            let msg = PImageMessageImpl(id: messages.count+1, sender: outgoingSender(), image: image!)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    
    
    func didStartRecordingVoiceMessage(atUrl url: URL) {
        print("Voice recording  start")
    }
    
    func didEndRecordingVoiceMessage(atUrl url: URL) {
        print("Voice recording  END")
        let msg = PVoiceMessageImpl(id: messages.count+1, sender: outgoingSender(), date: Date(), voiceUrl: url)
        messages.append(msg)
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
    
    
    func didPressAccessoryButton(button: UIView, collectionView: UICollectionView) {
        //Parla.config.accessoryActionChooser?.show()
        print("Did press accessory button")
    }
    
    func outgoingSender() -> POutgoingSender {
        return mainSender
    }
    
    func messageForCell(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage {
        return self.messages[indexPath.row]
    }
    
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int {
        return self.messages.count
    }
    
}
