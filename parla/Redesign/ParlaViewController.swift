//
//  ParlaViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

public protocol ParlaDataSource {
    var sender: PSender! { get set }
    
   // func bubbleViewForItem(at indexPath: IndexPath) -> AbstractMessageCell
    func messageForBubbble(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int
}

public protocol ParlaDelegate {
    func didTapMessageBubble(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView)
    func didPressSendButton(withMessage message: PMessage, textField: UITextField, collectionView: UICollectionView)
    func didPresAccessoryButton(button: UIButton, collectionView: UICollectionView)
    func didStartPickingImage(collectionView: UICollectionView)
    func didFinishPickingImage(with image:UIImage?, collectionView: UICollectionView)
    func didFinishPickingVideo(with: URL?, collectionView: UICollectionView)
}

open class ParlaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, AccessoryActionChooserDelegate {

    public var parlaDataSource: ParlaDataSource!
    public var parlaDelegate: ParlaDelegate?
    public var config: Parla!
    
    var inputToolbarContainer: UIView?
    var collectionView: UICollectionView!
    var textFieldContainer: UIView!
    var textField: UITextField!
    var chatContainerView: UIView!
    var accessoryButton: UIButton!
    var microphoneButton: UIButton!
    var bottom: NSLayoutConstraint!
    
    
    ///  ********* ========== Collection View Methods ========== **************  ///
    public final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = parlaDataSource.messageForBubbble(at: indexPath, collectionView: collectionView)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: message.cellIdentifier, for: indexPath) as! AbstractMessageCell
        
        cell.viewController = self
        cell.indexPath = indexPath
        cell.content = message
        cell.initialize()
        
        return cell
    }
    
    public final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.parlaDataSource
            .messageForBubbble(at: indexPath, collectionView: collectionView)
            .displaySize(frameWidth: collectionView.frame.width)
    }
    
    public final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parlaDataSource.numberOfMessagesIn(collectionView: collectionView)
    }
    
    public final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Parla.config.sectionInsets.left
    }
    
    public final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Parla.config.sectionInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item at index path: \(indexPath)")
    }
    /// ************** =========================== ****************** ///
    

    
    ///  ********* ========== UI Gesture Recognizers ========== **************  ///
    @objc private func onSendButtonPressed(_ sender: UITapGestureRecognizer) {
        if !textField.text!.isEmpty {
            //   let sm = SMessage(senderId: self.sender.id, senderName: self.sender.name, text: textField.text!, date: Date(), senderAvatar: self.sender.avatarImage)
            
            let sm = PTextMessageImpl(id: self.parlaDataSource.numberOfMessagesIn(collectionView: collectionView)+1,
                                      sender: self.parlaDataSource.sender,
                                      text: textField.text!,
                                      date: Date())
            
            self.parlaDelegate?.didPressSendButton(withMessage: sm, textField: self.textField, collectionView: self.collectionView)
        }
    }
    
    @objc private func onAccessoryButtonPressed(_ sender: UITapGestureRecognizer) {
        self.parlaDelegate?.didPresAccessoryButton(button: self.accessoryButton, collectionView: collectionView)
        
        if !config.accessoryButton.preventDefault {
            config.accessoryActionChooser?.show()
        }
    }
    /// ************** =========================== ****************** ///
    
    
    
    
    ///  ********* ========== Delegate Methods ========== **************  ///
    
    public func didChooseAccessoryAction(with action: AccessoryAction?, ofType type: AccessoryActionType) {
        print("Accessory action selected: == >> \(type) << ==")
        action?()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // self.inputToolbarContainerHeightConstraint.constant += 19
        //self.inputToolbarTextFieldHeightConstraint.constant += 19
        
        
        //self.collectionView.layoutIfNeeded()
        
        return true
    }
    
    /// ************** =========================== ****************** ///

    private func chooseImageFrom(source: MediaPickerSource)  {
        self.parlaDelegate?.didStartPickingImage(collectionView: self.collectionView)
        
        self.config.mediaPicker?.pickImage(source: source) {
            self.parlaDelegate?.didFinishPickingImage(with: $0, collectionView: self.collectionView)
        }
    }
    
    private func chooseVideoFrom(source: MediaPickerSource)  {
   //     self.parlaDelegate?.didStartPickingImage(collectionView: self.collectionView)
        
        self.config.mediaPicker?.pickVideo(source: source) {
            self.parlaDelegate?.didFinishPickingVideo(with: $0, collectionView: self.collectionView)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        config = Parla.config!
        config.mediaPicker = SystemMediaPicker(viewController: self)
        config.accessoryActionChooser = ActionSheetAccessoryActionChooser(viewController: self)
        config.accessoryActionChooser?.delegate = self
        
        config.accessoryActionChooser?.accessoryActions = [
            .chooseVideoFromGallery :  {  self.chooseVideoFrom(source: .photoLibrary) },
            .chooseImageFromGallery : {  self.chooseImageFrom(source: .photoLibrary) },
            .pickImageFromCamera :  {  self.chooseImageFrom(source: .camera) },
            .pickVideoFromCamera :  {  self.chooseVideoFrom(source: .camera) }
        ]
  
        if self.chatContainerView == nil {
            self.chatContainerView = self.view
        }
        
        //let b = Bundle.main
        
        let b = Bundle(for: ParlaViewController.self)
        
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
        self.accessoryButton = chatView.subviews[1].subviews[3] as? UIButton
        self.microphoneButton = chatView.subviews[1].subviews[2].subviews[1] as? UIButton
        
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSendButtonPressed(_:))))
        self.accessoryButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onAccessoryButtonPressed(_:))))
        
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
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UIApplication.shared.isStatusBarHidden = false
    }
    
    
    
    @objc public  func keyboardWillShow(_ notification: NSNotification) {
        // print(notification.userInfo)
        
        // We need the  keyboard height
        let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        print("keyboard size: \(keyboardSize)")
        
        bottom.constant -= keyboardSize.height + 20
        self.collectionView.scrollToBottom(animated: true)
    }
    
    @objc public func keyboardWillHide(_ notification: NSNotification) {
        
       // let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
    
        bottom.constant = -35
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
