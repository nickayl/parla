# Parla
Parla is a modern and user-friendly Chat UI library for iOS. It has been built with flexibility in mind: There are a lot of things that you can change!

It is really easy to use, it requires only little configuration and you are ready to start!

<img src="https://github.com/cyclonesword/parla/blob/master/parla/Test%20Resources/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-18%20at%2012.17.46.png" width="276" height="598"><img src="https://github.com/cyclonesword/parla/blob/master/parla/Test%20Resources/Simulator%20Screen%20Shot%20-%20iPhone%20X%CA%80%20-%202019-05-18%20at%2012.17.41.png" width="276" height="598">


## Installation
### CocoaPods
Documentation under construction

### Carthage
Carthage support will be soon available

## Usage
### Quick Start Guide

A complete functioning ViewController with test values:

    import UIKit
    import CoreLocation

    class MyViewController : UIViewController, ParlaViewDataSource, ParlaViewDelegate, VoiceRecorderDelegate, CLLocationManagerDelegate  {

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
            parlaView.initialize(dataSource: self, delegate: self, voiceRecorderDelegate: self)

            // This is a test video taken from the main bundle.
            let mondello = Bundle.main.url(forResource: "mondello", withExtension: "mp4")!

            // Adding some test messages
            self.messages = [
                PTextMessageImpl(id: 1, sender: mSender, text: "Hi Chiara! How are you? :)"),
                PTextMessageImpl(id: 2, sender: chiara, text: "Hi Domenico, all right! I'm sitting on a deckchiar here in the wonderful beach of Mondello, in Palermo (Italy)  :)"),
                PTextMessageImpl(id: 3, sender: mSender, text: "Waw! Tha's awesome! I can't wait to see a picture of you in this wonderful place!"),
                PImageMessageImpl(id: 4, sender: chiara, image: UIImage(named: "mondello-beach.jpg")!),
                PVideoMessageImpl(id: 5, sender: chiara, videoUrl: mondello),
                PTextMessageImpl(id: 6, sender: mSender, text: "Amazing, i'm coming right now!")
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


        func voiceRecorderDidEndRecording(at url: URL, voiceRecorder: VoiceRecorder) {
            print("did finish recording voice")
            let msg = PVoiceMessageImpl(id: messages.count+1, sender: mainSender(), date: Date(), voiceUrl: url)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }

        func voiceRecorderDidStartRecording(at url: URL, voiceRecorder: VoiceRecorder) {
            print("Voice recording  START")
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


