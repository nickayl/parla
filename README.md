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

In the view you want to display the Chat UI, set the custom class as  ```ParlaView``` :
<img src="https://github.com/cyclonesword/parla/blob/master/parla/Test%20Resources/github_task_1.png?raw=true" width="821" height="84">

Don't forget to bind the ParlaView view with an outlet inside your custom ViewController class.

Then in your ViewController, you need to implement at leat the ```ParlaViewDatasource``` class, but i highly reccomand to bind also the ```ParlaViewDelegate``` to receive notification when the user perform various operations (such us when press the send button, when it is recording a voice message etc.) :
```swift
class MyViewController : UIViewController, ParlaViewDataSource, ParlaViewDelegate { 
    // The main sender. His messages are considered as Outgoing, all the messages of other senders will be considerer as   Incoming messages.
    var mSender: PSender!
    
    // The array of messages
    var messages: [PMessage]!
    
    // The core of the library: The ParlaView class
    @IBOutlet var parlaView: ParlaView!
```

Then in your viewDidLoad add your custom logic, for example: 
```swift
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
```


