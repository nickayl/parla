//
//  NewViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit
import CoreLocation

class NewViewController : UIViewController, ParlaViewDataSource, ParlaViewDelegate, VoiceRecorderDelegate, CLLocationManagerDelegate  {
    
    var sender: PSender!
//    var otherSender: PSender!
   // var attachedViewController: UIViewController!
    
    private var collectionView: UICollectionView!
    private var locationManager: CLLocationManager!
    private var domenico: PSender!
    
    var messages: [PMessage]!
    
    @IBOutlet var parlaView: ParlaView!
    
    override func viewDidLoad() {

        // Initialization of ParlaView class
       
    //    self.attachedViewController = self
        self.parlaView.delegate = self
        self.parlaView.dataSource = self
        
//        Parla.config.cell.textMessageBubbleIncomingColor = UIColor.red
//        Parla.config.cell.textMessageBubbleOutgoingColor = UIColor.green
//        
//        Parla.config.cell.textIncomingColor = UIColor.blue
//        Parla.config.cell.textOutgoingColor = UIColor.yellow
//        
//        Parla.config.cell.voiceOutgoingColor = UIColor.cyan
//        Parla.config.avatar.size = CGSize(width: 30, height: 30)
        
      //  let avatar = PAvatar(withImage: UIImage(withBackground: UIColor.green))
        let avatar = PAvatar(withImage: UIImage(named: "avatarDefault")!)
        self.parlaView.voiceRecorderDelegate = self
        
//        self.sender = PSender(senderId: 0, senderName: "Gabriele", avatar: nil, type: .Outgoing)
//        self.otherSender = PSender(senderId: 1, senderName: "Ciccio", avatar: avatar, type: .Incoming)
        
        let config = Parla.config
        
      //  config.containerViewController = self
        config.accessoryButton.preventDefault = false
        config.cell.cellBottomLabelHidden = false
        config.avatar.isAvatarHidden = false
        config.avatar.avatarBackgroundColor = UIColor.black
        
        
//        let testVideo = Bundle.main.url(forResource: "video", withExtension: "mp4")!
//        let voiceTest = Bundle.main.url(forResource: "Imagine", withExtension: "mp3")!
        
//        self.messages = [
//            PVoiceMessageImpl(id: 5, sender: sender, date: Date(), voiceUrl: voiceTest),
//            PTextMessageImpl(id: 1, sender: sender, text: "Ciao ciccio!", date: Date()),
//            PTextMessageImpl(id: 2, sender: otherSender, text: "Ciao Gabri! Come va?"),
//            PImageMessageImpl(id: 3, sender: sender, image: UIImage(named: "doc.jpg")!, date: Date()),
//            PVideoMessageImpl(id: 4, sender: sender, videoUrl: testVideo)
//        ]
        
        
        let domenicoAvatar = PAvatar(withImage: UIImage(named: "domenico.jpeg")!)
        let chiaraAvatar = PAvatar(withImage: UIImage(named: "chiara.jpg")!)
        let mondello = Bundle.main.url(forResource: "mondello", withExtension: "mp4")!
        
        domenico = PSender(senderId: 10, senderName: "Domenico", avatar: domenicoAvatar, type: .Outgoing)
        let chiara = PSender(senderId: 11, senderName: "Chiara", avatar: chiaraAvatar, type: .Incoming)
        
        config.sender = domenico
        sender = domenico
        
        self.messages = [
            PTextMessageImpl(id: 1, sender: domenico, text: "Hi Chiara! How are you? :)"),
            PTextMessageImpl(id: 2, sender: chiara, text: "Hi Domenico, all right! I'm sitting on a deckchiar here in the wonderful beach of Mondello, in Palermo (Italy) ! :)"),
            PTextMessageImpl(id: 3, sender: domenico, text: "Waw! Tha's awesome! I can't wait to see a picture of you in this wonderful place!"),
            PImageMessageImpl(id: 4, sender: chiara, image: UIImage(named: "mondello-beach.jpg")!),
            PVideoMessageImpl(id: 5, sender: chiara, videoUrl: mondello),
        ]
        
        for i in 0 ..< a.count {
            if i % 2 == 0 {
              //  self.messages.append(PTextMessageImpl(id: i+4, sender: sender, text: a[i]))
            } else {
             //   self.messages.append(PTextMessageImpl(id: i+4, sender: otherSender, text: a[i]))
            }
        }
        
        for i in 0 ..< messages.count {
            messages[i].isTopLabelActive = (i % 4 == 0)
        }
        
        self.parlaView.initialize()
        self.collectionView = parlaView.collectionView
   //     locationManager.requestWhenInUseAuthorization()
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
            let msg = PVideoMessageImpl(id: messages.count+1, sender: sender, videoUrl: url)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    func didFinishPickingImage(with image: UIImage?, collectionView: UICollectionView) {
        if image != nil {
            let msg = PImageMessageImpl(id: messages.count+1, sender: sender, image: image!)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    func mainSender() -> PSender {
        return domenico
    }
    

    func voiceRecorderDidEndRecording(at url: URL, voiceRecorder: VoiceRecorder) {
        print("did finish recording voice")
        let msg = PVoiceMessageImpl(id: messages.count+1, sender: sender, date: Date(), voiceUrl: url)
        messages.append(msg)
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
    
    func voiceRecorderDidStartRecording(at url: URL, voiceRecorder: VoiceRecorder) {
        print("Voice recording  START")
    }
    
    
    func didPressAccessoryButton(button: UIButton, collectionView: UICollectionView) {
        print("Did press accessory button")
    }
    
    func messageForCell(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage {
        return self.messages[indexPath.row]
    }
    
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int {
        return self.messages.count
    }
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    let a: Array<String> = [
        "tretretretretretretretretretre",
        "tretretretretretretretretre",
        "tretretretretretretretre",
        "tretretretretretretre",
        "tretretretretretre",
        "tretretretretre",
        "tretretretre",
        "tretretre",
        "tretre",
        "tre",
        "Calling - (void)drawWithRect:(NSRect)rect",
        "Calling - (void)drawWithRect:(NSRect)rect options:(NSStringDrawingOptions)options with a rect shaped to the width I want and NSStringDrawingUsesLineFragmentOrigin in the options, exactly as I'm using in my drawing. The results are ... difficult to understand; certainly not what I'm looking for. (As is pointed out in a number of places, including this Cocoa-Dev thread).",
        
        "Draws the attributed string in the specified bounding rectangle using the provided options.When I query the frame of tmpView, the width is still as desired, and the height is often correct ... until I get to longer strings, when it's often half the size that's required. (There doesn't seem to be a max size being hit: one frame will be 273.0 high (about 300 too short), the other will be 478.0 (only 60-ish too short)).",
        
        "terzoaaaaaa",
        "ciao",
        "quartoqa", "Calling - (void)drawWithRect:(NSRect)rect options:(NSStringDrawingOptions)",
        
        "You might be interested in Jerry Krinock's great (OS X only) NS(Attributed)String+Geometrics category, which is designed to do all sorts of string measurement, including what you're looking for.",
        "Ciaooo\n\n\nciaociao",
        
        "In statistical thermodynamics, entropy (usual symbol S) (Greek:Εντροπία, εν + τρέπω) is a measure of the number of microscopic configurations Ω that correspond to a thermodynamic system in a state specified by certain macroscopic variables. Specifically, assuming that each of the microscopic configurations is equally probable, the entropy of the system is the natural logarithm of that number of configurations, multiplied by the Boltzmann constant kB (which provides consistency with the original thermodynamic concept of entropy discussed below, and gives entropy the dimension of energy divided by temperature). For example, gas in a container with known volume, pressure, and temperature could have an enormous number of possible configurations of the individual gas molecules, and which configuration the gas is actually in may be regarded as random. Hence, entropy can be understood as a measure of molecular disorder within a macroscopic system. The second law of thermodynamics states that an isolated system's entropy never decreases. Such systems spontaneously evolve towards thermodynamic equilibrium, the state with maximum entropy. Non-isolated systems may lose entropy, provided their environment's entropy increases by at least that decrement. Since entropy is a state function, the change in entropy of a system is determined by its initial and final states. This applies whether the process is reversible or irreversible. However, irreversible processes increase the combined entropy of the system and its environment.The change in entropy (ΔS) of a system was originally defined for a thermodynamically reversible process as where T is the absolute temperature of the system, dividing an incremental reversible transfer of heat into that system (δQrev). (If heat is transferred out the sign would be reversed giving a decrease in entropy of the system.) The above definition is sometimes called the macroscopic definition of entropy because it can be used without regard to any microscopic description of the contents of a system. The concept of entropy has been found to be generally useful and has several other formulations. Entropy was discovered when it was noticed to be a quantity that behaves as a function of state, as a consequence of the second law of thermodynamics.",
        "In statistical thermodynamics, entropy (usual symbol S) (Greek:Εντροπία, εν + τρέπω) is a measure of the number of microscopic configurations Ω that correspond to a thermodynamic system in a state specified by certain macroscopic variables. Specifically, assuming that each of the microscopic configurations is equally probable, the entropy of the system is the natural logarithm of that number of configurations, multiplied by the Boltzmann constant kB (which provides consistency with the original thermodynamic concept of entropy discussed below, and gives entropy the dimension of energy divided by temperature). For example, gas in a container with known volume, pressure, and temperature could have an enormous number of possible configurations of the individual gas molecules, and which configuration the gas is actually in may be regarded as random. Hence, entropy can be understood as a measure of molecular disorder within a macroscopic system. The second law of thermodynamics states that an isolated system's entropy never decreases. Such systems spontaneously evolve towards thermodynamic equilibrium, the state with maximum entropy. Non-isolated systems may lose entropy, provided their. ",
        "Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!.Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!Presto festeggeremo il nostro passeggero 10 milioni che volerà con Volotea. Vogliamo dargli un premio molto speciale, per questo ci piacerebbe ricevere la tua proposta di regalo di Natale. Se la tua proposta di regalo viene scelta, anche tu riceverai il premio!"]

}
