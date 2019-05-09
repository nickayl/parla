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
    
    func didTapMessageBubble(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView)
    func didPressSendButton(withMessage message: PMessage, textField: UITextField, collectionView: UICollectionView)
    func didPresAccessoryButton(button: UIButton, collectionView: UICollectionView)
    
}

class ParlaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    var parlaDataSource: ParlaDataSource!
    var parlaDelegate: ParlaDelegate?
    
    var inputToolbarContainer: UIView?
    var collectionView: UICollectionView!
    var textFieldContainer: UIView!
    var textField: UITextField!
    var chatContainerView: UIView!
    
    var bottom: NSLayoutConstraint!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = parlaDataSource.messageForBubbble(at: indexPath, collectionView: collectionView)
        
//        if var imageMessage = message as? PImageMessage {
//            imageMessage.viewController = self
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: message.cellIdentifier, for: indexPath) as! AbstractMessageCell
        
        cell.viewController = self
        cell.indexPath = indexPath
        cell.content = message
        cell.initialize()
        
        return cell
    }
    
    @objc func onSendButtonPressed(_ sender: UITapGestureRecognizer) {
        if !textField.text!.isEmpty {
         //   let sm = SMessage(senderId: self.sender.id, senderName: self.sender.name, text: textField.text!, date: Date(), senderAvatar: self.sender.avatarImage)
            
            let sm = PTextMessageImpl(id: self.parlaDataSource.numberOfMessagesIn(collectionView: collectionView)+1,
                                      sender: self.parlaDataSource.sender,
                                      text: textField.text!,
                                      date: Date())
            
            self.parlaDelegate?.didPressSendButton(withMessage: sm, textField: self.textField, collectionView: self.collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.parlaDataSource
            .messageForBubbble(at: indexPath, collectionView: collectionView)
            .displaySize(frameWidth: collectionView.frame.width)
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
        collectionView.register(UINib(nibName: incomingVideoMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingVideoMessageReuseIdentifier)
        collectionView.register(UINib(nibName: outgoingVideoMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingVideoMessageReuseIdentifier)
        collectionView.register(UINib(nibName: incomingVoiceMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingVoiceMessageReuseIdenfitier)
        
        chatView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //   self.view.translatesAutoresizingMaskIntoConstraints = false
        
        if parlaDataSource.sender.id < 0 || parlaDataSource.sender.name.isEmpty {
            assertionFailure("Fatal error: You must specify a senderId and a senderName by subclassing sender() medthod.")
            return ;
        }
        
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
        
        bottom.constant -= keyboardSize.height + 20
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
       // let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
    
        bottom.constant = -35
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at index path: \(indexPath)")
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
