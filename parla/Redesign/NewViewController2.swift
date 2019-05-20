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
    var mSender: PSender!
    
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
        self.mSender = PSender(senderId: 10, senderName: "Domenico", avatar: domenicoAvatar, type: .Outgoing)
        let chiara = PSender(senderId: 11, senderName: "Chiara", avatar: chiaraAvatar, type: .Incoming)
        
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
            Parla.newTextMessage(id: 1, sender: mSender, text: "Hi Chiara! How are you? :)"),
            Parla.newTextMessage(id: 2, sender: chiara, text: "Hi Domenico, all right! I'm sitting on a deckchiar here in the wonderful beach of Mondello, in Palermo (Italy)  :)"),
            Parla.newTextMessage(id: 3, sender: mSender, text: "Waw! Tha's awesome! I can't wait to see a picture of you in this wonderful place!"),
            Parla.newImageMessage(id: 4, sender: chiara, image: UIImage(named: "mondello-beach.jpg")!),
            Parla.newVideoMessage(id: 5, sender: chiara, videoUrl: mondello),
            Parla.newTextMessage(id: 6, sender: mSender, text: "Amazing, i'm coming right now!"),
            Parla.newVoiceMessage(id: 7, sender: chiara, voiceUrl: URL(string: "file:///Users/MacBookPro/Library/Developer/CoreSimulator/Devices/4619688B-BFB8-4B22-AAC6-501136DF6168/data/Containers/Data/Application/96E77E80-6000-4216-BCF9-3A45578A0DEB/Documents/voice_Domenico_1558335874.020494.m4a")!)
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
            let msg = PVideoMessageImpl(id: messages.count+1, sender: mainSender(), videoUrl: url)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    func didFinishPickingImage(with image: UIImage?, collectionView: UICollectionView) {
        if image != nil {
            let msg = PImageMessageImpl(id: messages.count+1, sender: mainSender(), image: image!)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    func mainSender() -> PSender {
        return mSender
    }
    
    
    func didStartRecordingVoiceMessage(atUrl url: URL) {
        print("Voice recording  start")
    }
    
    func didEndRecordingVoiceMessage(atUrl url: URL) {
        print("Voice recording  END")
        let msg = PVoiceMessageImpl(id: messages.count+1, sender: mainSender(), date: Date(), voiceUrl: url)
        messages.append(msg)
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
    
    
    func didPressAccessoryButton(button: UIView, collectionView: UICollectionView) {
        print("Did press accessory button")
    }
    
    func messageForCell(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage {
        return self.messages[indexPath.row]
    }
    
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int {
        return self.messages.count
    }
    
}
