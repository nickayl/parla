//
//  NewViewController.swift
//  parla
//
//  Created by Domenico Gabriele Aiello on 09/05/2019.
//  Copyright © 2019 com.cyclonesword. All rights reserved.
//

import UIKit

class NewViewController: ParlaViewController, ParlaDataSource, ParlaDelegate {
    
    var sender: PSender!
    var otherSender: PSender!
    
    var messages: [PMessage]!
    
    override func viewDidLoad() {

      //  let avatar = PAvatar(withImage: UIImage(withBackground: UIColor.green))
        let avatar = PAvatar(withImage: UIImage(named: "avatarDefault")!)
        
        self.sender = PSender(senderId: 0, senderName: "Domenico", avatar: nil, type: .Outgoing)
        self.otherSender = PSender(senderId: 1, senderName: "Ciccio", avatar: avatar, type: .Incoming)
        
        Parla.config = Parla(withSender: sender)
        let config = Parla.config!
        config.cellBottomLabelHidden = false
        config.isAvatarHidden = false
        config.avatarBackgroundColor = UIColor.black
        config.containerViewController = self
        
        let testVideo = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        
        self.messages = [
            PTextMessageImpl(id: 1, sender: sender, text: "Ciao ciccio!", date: Date()),
            PTextMessageImpl(id: 2, sender: otherSender, text: "Ciao Domenico! Come butta?"),
            PImageMessageImpl(id: 3, sender: sender, image: UIImage(named: "doc.jpg")!, date: Date()),
            PVideoMessageImpl(id: 4, sender: sender, videoUrl: testVideo)
        ]
        
        for i in 0 ..< a.count {
            if i % 2 == 0 {
                self.messages.append(PTextMessageImpl(id: i+4, sender: sender, text: a[i]))
            } else {
                self.messages.append(PTextMessageImpl(id: i+4, sender: otherSender, text: a[i]))
            }
        }
        
        self.parlaDelegate = self
        self.parlaDataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func didTapMessageBubble(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView) {
        message.triggerSelection()
        
    }
    
    func didPressSendButton(withMessage message: PMessage, textField: UITextField, collectionView: UICollectionView) {
        self.messages.append(message)
        
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
    
    func didPresAccessoryButton(button: UIButton, collectionView: UICollectionView) {
        
    }
    
    func messageForBubbble(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage {
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
