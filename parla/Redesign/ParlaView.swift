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
    var attachedViewController: UIViewController! { get set }
    
    func messageForCell(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int
}

@objc public protocol ParlaDelegate {
    
    // General delegate functions
    func didTapMessageBubble(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView)
    func didLongTouchMessage(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView)
    func didPressSendButton(withMessage message: PMessage, textField: UITextField, collectionView: UICollectionView)
    func didPressAccessoryButton(button: UIButton, collectionView: UICollectionView)
    // ==========
    
    // === Optional functions ======= //
    
    // Accessory button delegate functions
    
    @objc optional func didStartPickingImage(collectionView: UICollectionView)
    @objc optional func didFinishPickingImage(with image:UIImage?, collectionView: UICollectionView)
    
    @objc optional func didStartPickingVideo(with: URL?, collectionView: UICollectionView)
    @objc optional func didFinishPickingVideo(with: URL?, collectionView: UICollectionView)
    // ==========
    
}

open class ParlaView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, AccessoryActionChooserDelegate  {

    public var parlaDataSource: ParlaDataSource!
    public var parlaDelegate: ParlaDelegate?
    public var config: Parla!
    
    private var viewController: UIViewController {
        get {
            return parlaDataSource.attachedViewController
        }
    }
    
    public var voiceRecorderDelegate: VoiceRecorderDelegate? {
        willSet {
            self.recorder?.delegate = newValue
        }
    }
    
    var inputToolbarContainer: UIView?
    var collectionView: UICollectionView!
    var textFieldContainer: UIView!
    var textField: UITextField!
    var chatContainerView: UIView!
    var accessoryButton: UIButton!
    var microphoneButton: UIButton!
    var bottomConstraint: NSLayoutConstraint!
    
    private var keyboardDefaultBottomConstraintMargin = CGFloat(-35)
    private var keyboardStarterBottomMargin = CGFloat(20)
    private var recorder: VoiceRecorder?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.recorder = DefaultVoiceRecorder()
    }
    
    ///  ********* ========== Collection View Methods ========== **************  ///
    public final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = parlaDataSource.messageForCell(at: indexPath, collectionView: collectionView)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: message.cellIdentifier, for: indexPath) as! AbstractMessageCell
        
        cell.viewController = self
        cell.indexPath = indexPath
        cell.content = message
        cell.initialize()
        
        return cell
    }
    
    public final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.parlaDataSource
            .messageForCell(at: indexPath, collectionView: collectionView)
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
            let sm = PTextMessageImpl(id: self.parlaDataSource.numberOfMessagesIn(collectionView: collectionView)+1,
                                      sender: self.parlaDataSource.sender,
                                      text: textField.text!,
                                      date: Date())
            
            self.parlaDelegate?.didPressSendButton(withMessage: sm, textField: self.textField, collectionView: self.collectionView)
        }
    }
    
    @objc private func onAccessoryButtonPressed(_ sender: UITapGestureRecognizer) {
        self.parlaDelegate?.didPressAccessoryButton(button: self.accessoryButton, collectionView: collectionView)
        
        if !config.accessoryButton.preventDefault {
            config.accessoryActionChooser?.show()
        }
    }
    
    @objc private func onMicrophoneButtonPressed(_ sender: UITapGestureRecognizer) {
        
        if let r = recorder, !r.isRecording {
            let fname = "voice_\(config.sender.name)_\(Date().timeIntervalSince1970).m4a"
            self.recorder?.audioUrl = URL.documentsDirectory.appendingPathComponent(fname)
            print(fname)
        }
        
        
        do {
            try self.recorder?.toggle()
        } catch {
            print("An error occurred recording voice message: \(error)")
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
        
        return true
    }
    
    /// ************** =========================== ****************** ///

    private func chooseImageFrom(source: MediaPickerSource)  {
        self.parlaDelegate?.didStartPickingImage?(collectionView: self.collectionView)
        
        self.config.mediaPicker?.pickImage(source: source) {
            self.parlaDelegate?.didFinishPickingImage?(with: $0, collectionView: self.collectionView)
        }
    }
    
    private func chooseVideoFrom(source: MediaPickerSource)  {
   //     self.parlaDelegate?.didStartPickingImage(collectionView: self.collectionView)
        
        self.config.mediaPicker?.pickVideo(source: source) {
            self.parlaDelegate?.didFinishPickingVideo?(with: $0, collectionView: self.collectionView)
        }
    }
    
    
    open func initialize() {

        if parlaDataSource == nil || parlaDataSource.sender == nil {
            assertionFailure("Fatal error: You must provide a dataSource and a sender to your viewController class (Implement the ParlaDataSource protocol and assign a valid sender instance to the sender property)")
            return ;
        }
        
        let model = Utils.getModelNumber()
        
        if model.0 < 10 {
            keyboardDefaultBottomConstraintMargin = 0
            keyboardStarterBottomMargin = 0
        } else if model.0 > 10 && (model.1 < 5 && model.1 != 3) {
            keyboardDefaultBottomConstraintMargin = 0
            keyboardStarterBottomMargin = 0
        }
        
        print("\(model) == c: \(keyboardDefaultBottomConstraintMargin)")
        
        print("Currently running on iPhone model \(UIDevice.current.modelName)")
        
        config = Parla.config!
        config.mediaPicker = SystemMediaPicker(viewController: self.viewController)
        config.accessoryActionChooser = ActionSheetAccessoryActionChooser(viewController: self.viewController)
        config.accessoryActionChooser?.delegate = self
        
        config.accessoryActionChooser?.accessoryActions = [
            .chooseVideoFromGallery :  {  self.chooseVideoFrom(source: .photoLibrary) },
            .chooseImageFromGallery : {  self.chooseImageFrom(source: .photoLibrary) },
            .pickImageFromCamera :  {  self.chooseImageFrom(source: .camera) },
            .pickVideoFromCamera :  {  self.chooseVideoFrom(source: .camera) }
        ]
  
        if self.chatContainerView == nil {
            self.chatContainerView = self
        }
        
        //let b = Bundle.main
        
        let b = Bundle(for: ParlaView.self)
        
        let nib = UINib(nibName: "ParlaCollectionView", bundle: b)
        let chatView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        self.chatContainerView.addSubview(chatView)
        self.bottomConstraint = NSLayoutConstraint(item: chatView, attribute: .bottom, relatedBy: .equal, toItem: self.chatContainerView, attribute: .bottom, multiplier: 1, constant: keyboardDefaultBottomConstraintMargin)
        let top = NSLayoutConstraint(item: chatView, attribute: .top, relatedBy: .equal, toItem: self.chatContainerView, attribute: .top, multiplier: 1, constant: -keyboardDefaultBottomConstraintMargin)
        
        self.chatContainerView.addConstraints([
            self.bottomConstraint,
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
        self.microphoneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMicrophoneButtonPressed(_:))))
        
        
        self.textField = chatView.subviews[1].subviews[2].subviews[0] as? UITextField
        self.textField.delegate = self
        
        collectionView.register(UINib(nibName: incomingTextMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingTextMessageReuseIdentifier)
        collectionView.register(UINib(nibName: outgoingTextMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingTextMessageReuseIdentifier)
        collectionView.register(UINib(nibName: incomingImageMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingImageMessageReuseIdentifier)
        collectionView.register(UINib(nibName: outgoingImageMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingImageMessageReuseIdentifier)
        collectionView.register(UINib(nibName: incomingVideoMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingVideoMessageReuseIdentifier)
        collectionView.register(UINib(nibName: outgoingVideoMessageXibName, bundle: b), forCellWithReuseIdentifier: outgoingVideoMessageReuseIdentifier)
        collectionView.register(UINib(nibName: incomingVoiceMessageXibName, bundle: b), forCellWithReuseIdentifier: incomingVoiceMessageReuseIdenfitier)
        collectionView.register(UINib(nibName: "VoiceMessageCell", bundle: b), forCellWithReuseIdentifier: voiceMessageReuseIdentifier )
        
        chatView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        //   self.view.translatesAutoresizingMaskIntoConstraints = false

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.textFieldContainer.setBorderRadius(radius: 7)
        self.textField.setBorderRadius(radius: 6)
        
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0);
    }
    
//    override open func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//       // UIApplication.shared.isStatusBarHidden = false
//    }
    
    
    @objc public final func keyboardWillShow(_ notification: NSNotification) {
        // print(notification.userInfo)
        
        // We need the  keyboard height
        let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        print("keyboard size: \(keyboardSize)")
        
        bottomConstraint.constant -= keyboardSize.height + keyboardStarterBottomMargin
        self.collectionView.scrollToBottom(animated: true)
    }
    
    @objc public final func keyboardWillHide(_ notification: NSNotification) {
        
       // let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
    
        bottomConstraint.constant = CGFloat(keyboardDefaultBottomConstraintMargin)
    }
    

}
