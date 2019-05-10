//
//  ChatViewController.swift
//  doctorchat
//
//  Created by Domenico Gabriele Aiello on 31/12/16.

//  Licenced under The MIT License (MIT)
//
//  Copyright © 2016 All rights reserved. Created and mantained by Domenico Aiello.
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import SKPhotoBrowser
import MobilePlayer
import AVKit

extension ChatViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfMessagesIn(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message: SMessage = self.messageForBubbble(at: indexPath, collectionView: collectionView)
        var cellIdentifier: String
        
        let type = message.messageType
        let senderType = message.senderType
        
        // Text message
        if type == .TextMessage && senderType == .Incoming {
            //cellIdentifier = "BubbleCellViewIDTextIncoming"
            cellIdentifier = incomingTextMessageReuseIdentifier
        }
        else if type == .TextMessage && senderType == .Outgoing {
            cellIdentifier = outgoingTextMessageReuseIdentifier
        }
        // ----
        
        // Image and Video message
        else if (type == .ImageMessage || type == .VideoMessage) && senderType == .Outgoing {
            cellIdentifier = incomingImageMessageReuseIdentifier
        }
        else if (type == .ImageMessage || type == .VideoMessage) && senderType == .Incoming {
            cellIdentifier = outgoingImageMessageReuseIdentifier
        }
        // ---
        
        // Voice message
        else if type == .VoiceMessage  && senderType == .Incoming {
            cellIdentifier = incomingVoiceMessageReuseIdenfitier
        }
        else  {
            cellIdentifier = "BubbleCellViewIDVoiceOutgoing"
        }
        // ---
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BubbleViewCell
        
    
        cell.viewController = self
        cell.indexPath = indexPath
        
        return self.bubbleViewForItem(at: indexPath).fillCellView(reusableCell: cell)

    }
    
}

extension ChatViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = self.bubbleViewForItem(at: indexPath).calculateCellSize(collectionView: collectionView)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  insetForSectionAt section: Int) -> UIEdgeInsets {
        return SConfig.shared().bubbleImageText.sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SConfig.shared().bubbleImageText.sectionInsets.left
    }
    
}

/**
    Cose da fare: 
        
        1) CellTopLabel relativo al nome dell'utente che invia il messaggio (required+)
        2) Message bubble per le immagini  (urgent!)
        3) Message bubble per i video (urgent!)
        4) Formattazione in stile Messanger di Facebook (required)
        5) messaggi vocali (required-)
        6) Message bubble per le mappe (optional)
        7) Suono ad invio / ricezione messaggio (optional-)
        8) formattazione codice con design pattern ben studiati (urgent! ++)
        9) spaziatura tra le bubble per far capire chi invia e riceve (urgent! +)
 
         Tempo stimato per produrre una Release Candidate: 2 mesi
 */

class ChatViewController : UIViewController, UICollectionViewDelegate, UITextFieldDelegate, BubbleDataSource, BubbleDelegate, AVAudioRecorderDelegate  {

    @IBOutlet var inputToolbarContainer: UIView?
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var textFieldContainer: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var chatContainerView: UIView!
    
  //  @IBOutlet var inputToolbarTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bottom: NSLayoutConstraint!
  //  @IBOutlet var inputToolbarContainerHeightConstraint: NSLayoutConstraint!
    
    let textFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
    let itemsPerRow = CGFloat(1.0);
    var messages: [SMessage] = []
    var sender: SSender!
    
    let config = CellBubble.CellBubbleConfig()
//    private var bubbleSizeCalculator: CellSizeCalculator!
    
    private let incomingTextMessageXibName = "IncomingTextMessageCell", incomingTextMessageReuseIdentifier = "BubbleCellViewIDTextIncomingXib"
    private let outgoingTextMessageXibName = "OutgoingTextMessageCell", outgoingTextMessageReuseIdentifier = "BubbleCellViewIDTextOutgoingXib"
    private let incomingImageMessageXibName = "IncomingImageMessageCell", incomingImageMessageReuseIdentifier = "BubbleCellViewIDImageIncomingXib"
    private let outgoingImageMessageXibName = "OutgoingImageMessageCell", outgoingImageMessageReuseIdentifier = "BubbleCellViewIDImageOutgoingXib"
    private let incomingVoiceMessageXibName = "VoiceMessageCell", incomingVoiceMessageReuseIdenfitier = "BubbleCellViewIDVoiceIncomingXib"
    
    @IBAction func microphoneTouchDown(_ sender: UIButton) {
        print("Microphone touch DOWN")
        self.recordVoiceMessage()
    }
    
    @IBAction func microphoneTouchUp(_ sender: UIButton) {
        print("Microphone touch Up")
        
        let sm = SMessage(senderId: "56", senderName: "Cicciuzzo", voice:  self.stopRecordingVoice(), date: Date(), senderAvatar: nil)
        didPressSendButton(withMessage: sm, textField: self.textField, collectionView: self.collectionView)
    }
    
    @objc func onSendButtonPressed(_ sender: UITapGestureRecognizer) {
        if !textField.text!.isEmpty {
            let sm = SMessage(senderId: self.sender.id, senderName: self.sender.name, text: textField.text!, date: Date(), senderAvatar: self.sender.avatarImage)
            didPressSendButton(withMessage: sm, textField: self.textField, collectionView: self.collectionView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.chatContainerView == nil {
            self.chatContainerView = self.view
        }
        
        let b = Bundle.main
        
        let nib = UINib(nibName: "ParlaCollectionView", bundle: b)
        let chatView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.chatContainerView.addSubview(chatView)
        self.bottom = NSLayoutConstraint(item: chatView, attribute: .bottom, relatedBy: .equal, toItem: self.chatContainerView, attribute: .bottom, multiplier: 1, constant: -35)
        let top = NSLayoutConstraint(item: chatView, attribute: .top, relatedBy: .equal, toItem: self.chatContainerView, attribute: .top, multiplier: 1, constant: 35)
        
        self.chatContainerView.addConstraints([
            self.bottom,
            NSLayoutConstraint(item: chatView, attribute: .leading, relatedBy: .equal, toItem: self.chatContainerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: chatView, attribute: .trailing, relatedBy: .equal, toItem: self.chatContainerView, attribute: .trailing, multiplier: 1, constant: 0),
            top
            ])
        
        self.collectionView = chatView.subviews[0] as? UICollectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.inputToolbarContainer = chatView.subviews[1]
        self.textFieldContainer = chatView.subviews[1].subviews[2]
        let sendButton = chatView.subviews[1].subviews[1] as! UIButton
        
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSendButtonPressed(_:))))
        self.textField = chatView.subviews[1].subviews[2].subviews[0] as? UITextField
        self.textField.delegate = self
        
        collectionView.register(UINib(nibName: incomingTextMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingTextMessageReuseIdentifier)
        collectionView.register(UINib(nibName: outgoingTextMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingTextMessageReuseIdentifier)
        collectionView.register(UINib(nibName: incomingImageMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingImageMessageReuseIdentifier)
        collectionView.register(UINib(nibName: outgoingImageMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingImageMessageReuseIdentifier)
        collectionView.register(UINib(nibName: incomingVoiceMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingVoiceMessageReuseIdenfitier)
        
        chatView.translatesAutoresizingMaskIntoConstraints = false
     //   self.view.translatesAutoresizingMaskIntoConstraints = false
        
        if sender.id.isEmpty || sender.name.isEmpty {
            assertionFailure("Fatal error: You must specify a senderId and a senderName by subclassing sender() medthod.")
            return ;
        }
        
     //   self.bubbleSizeCalculator = CellSizeCalculator(mainView: self.chatContainerView, textFont: textFont)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.textFieldContainer.setBorderRadius(radius: 7)
        self.textField.setBorderRadius(radius: 6)
        
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIApplication.shared.isStatusBarHidden = false
    
    }
    
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    let audioFilename = URL.getDocumentsDirectory().appendingPathComponent("voice.m4a")
    
    private func recordVoiceMessage() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allowed to register audio")

                        let settings = [
                            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                            AVSampleRateKey: 12000,
                            AVNumberOfChannelsKey: 1,
                            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                        ]
                        
                        do {
                            self.audioRecorder = try AVAudioRecorder(url: self.audioFilename, settings: settings)
                            self.audioRecorder.delegate = self
                            
                            if !self.audioRecorder.isRecording {
                                self.audioRecorder.record()
                            }

                        } catch {
                            print(" failed to record! - 0")
                        }
                        
                    } else {
                        print(" failed to record! - 1")
                    }
                }
            }
        } catch {
            print(" failed to record! - 2")
        }
    }
    
    private func stopRecordingVoice() -> URL? {
        if audioRecorder != nil {
            audioRecorder.stop()
            print("Stopped voice recording and save file as voice.m4a")
            return audioFilename
        }
        
        return nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finish recording "+flag.description)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
       // self.inputToolbarContainerHeightConstraint.constant += 19
        //self.inputToolbarTextFieldHeightConstraint.constant += 19
        
        
        //self.collectionView.layoutIfNeeded()
        
        return true
    }
    
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // print(notification.userInfo)
        
        // We need the  keyboard height
        let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        print("keyboard size: \(keyboardSize)")
        
        /// --- Positions the inputToolbarContainer above the keyboard. ---
        
        // Positions the inputToolbar above the keyboard
       // self.inputToolbarContainer?.frame.origin.y -= keyboardSize.height
        
        // Then apply bottom insets to move the collection view content up
        //self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        
        // Scrolls the collection view to the last visible item (message). Section is 0 becouse here we have only one section , i.e. a message per cell.
       // self.collectionView!.scrollToBottom(animated: true)
        
        bottom.constant -= keyboardSize.height + 20
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {

        let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        
      //  self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //self.inputToolbarContainer?.frame.origin.y += keyboardSize.height
        
       // self.inputToolbarContainerHeightConstraint.constant = 44
        // self.inputToolbarTextFieldHeightConstraint.constant = 30
        bottom.constant = -35
        
      //  self.collectionView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at index path: \(indexPath)")
    }
    
    final func bubbleViewForItem(at indexPath: IndexPath) -> CellBubble {
        
        let m = self.messageForBubbble(at: indexPath, collectionView: self.collectionView)
        let cellBubble = CellBubble(message: m, indexPath: indexPath, config: nil)
        
        return cellBubble
    }
    
    func messageForBubbble(at indexPath: IndexPath, collectionView: UICollectionView) -> SMessage {
        return
            self.messages[indexPath.item]
    }
    
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    func didTapMessageBubble(at indexPath: IndexPath, collectionView: UICollectionView) {
        let m = self.messageForBubbble(at: indexPath, collectionView: collectionView)
        
        if m.messageType == .VideoMessage {
            if let videoURL = m.video {

                let playerVC = MobilePlayerViewController(contentURL: videoURL)
                playerVC.title = "\(m.senderName)'s video"
                playerVC.activityItems = [videoURL]

                presentMoviePlayerViewControllerAnimated(playerVC)
            }

        } else if m.messageType == .ImageMessage {
            let image = m.image
            
            let photo = SKPhoto.photoWithImage(image!)
            let browser = SKPhotoBrowser(photos: [photo])
            browser.initializePageIndex(0)

            present(browser, animated: true, completion: nil)
        }
        
    }
    
    func didPresAccessoryButton(button: UIButton, collectionView: UICollectionView) {
        
    }
   
    func didPressSendButton(withMessage message: SMessage, textField: UITextField, collectionView: UICollectionView) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
