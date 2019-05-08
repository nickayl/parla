//
//  DebuggingStuff.swift
//  Seneca
//
//  Created by Domenico Gabriele Aiello on 17/01/17.
//  Copyright © 2017 Domenico Aiello. All rights reserved.
//

import Foundation
import UIKit

class DebuggingStuff {
    
    static func initChat() -> Array<SMessage> {
        var mArray: Array<SMessage> = []
        
         let senderId: String = "0"
         let senderId2: String = "1"
        
         let senderName = "Domenico"
         let senderName2 = "Ciccio"

        
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
        var i = 0
        
        for s in a {
            
            if i % 2 == 0 {
                mArray.append(SMessage(senderId: senderId, senderName: senderName, text: s, date: Date(), senderAvatar: UIImage(named: "avatarDefault")!))
            } else {
                mArray.append(SMessage(senderId: senderId2, senderName: senderName2, text: s, date: Date(), senderAvatar: nil))
            }
            
            i += 1
           
            if i == 2 { // [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"html"]];
                var url: URL?
                
                if let x = Bundle.main.url(forResource: "video", withExtension: "mp4") {
                    url = x
                    print("url: "+url!.absoluteString)
                
                } else {
                    print("no resouce found")
                }
                
                
                mArray.append(SMessage(senderId: senderId, senderName: senderName,
                                       video: url , date: Date(),
                                       senderAvatar: UIImage(named:"avatarDefault")!))
                
                mArray.append(SMessage(senderId: senderId2, senderName: senderName2,
                                       video: url , date: Date(),
                                       senderAvatar: nil))
                
                mArray.append(SMessage(senderId: senderId2, senderName: senderName2, image: UIImage(named: "doc.jpg")!, date: Date(),
                                       senderAvatar: nil))

            }
            if i == 3 {
                mArray.append(SMessage(senderId: senderId, senderName: senderName, image: UIImage(named: "doc.jpg")!, date: Date(),
                                       senderAvatar: UIImage(named:"avatarDefault")!))
            }
            if i == 4 {
                mArray.append(SMessage(senderId: senderId2, senderName: senderName2, image: UIImage(named: "doc.jpg")!, date: Date(),
                                       senderAvatar: nil))
            }
            
            if i == 5 {
                mArray.append(SMessage(senderId: senderId2, senderName: senderName2, voice: Bundle.main.url(forResource: "Imagine", withExtension: "mp3"), date: Date(),
                                       senderAvatar: nil))
            }
        }
        
        return mArray
    }
    
}
