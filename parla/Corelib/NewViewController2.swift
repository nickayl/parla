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
    var mainSender: POutgoingSender!
    
    // The array of messages
    var messages: [PMessage]!
    
    // The core of the library: The ParlaView class
    @IBOutlet var parlaView: ParlaView!
    
    override func viewDidLoad() {
        
       
        // The avatars of the senders. If you do not want an avatar pass nil and disable avatar in the config
        // class before initializing: Parla.config.avatar.isHidden = true
        let domenicoAvatar = PAvatar(withImage: UIImage(named: "domenico.jpeg"))
        let chiaraAvatar = PAvatar(withImage: UIImage(named: "chiara.jpg"))
        
        // In this example we have 2 message senders
        mainSender = Parla.outgoingSender(id: 10, name: "Domenico", avatar: nil)
        let chiara = PIncomingSender(id: 11, name: "Chiara", avatar: chiaraAvatar)
        
        let config = Parla.config
        config.accessoryButton.preventDefault = false
        config.cell.isBottomLabelHidden = false
        
        
        // This color will be used if you pass a nil avatar to a sender but do not set the isHidden property to true.
        config.avatar.backgroundColor = UIColor.black
        
        // This is a test video taken from the main bundle.
        let mondello = Bundle.main.url(forResource: "mondello", withExtension: "mp4")!
        
        // Adding some test messages
        let fileurl = Bundle.main.url(forResource: "DICHIARAZIONE", withExtension: "pdf")!
        self.messages = [
            Parla.newTextMessage(id: 1, sender: mainSender, text: "Hi Chiara! How are you? :)", date: Date.fromString("20/09/1990", withFormat: "dd/MM/yyyy")!),
            Parla.newTextMessage(id: 2, sender: chiara, text: "Hi Domenico, all right! I'm sitting on a deckchiar here in the wonderful beach of Mondello, in Palermo (Italy)  :)"),
            Parla.newTextMessage(id: 3, sender: mainSender, text: "Waw! Tha's awesome! I can't wait to see a picture of you in this wonderful place!"),
            Parla.newImageMessage(id: 4, sender: chiara, image: UIImage(named: "mondello-beach.jpg")!),
            Parla.newVideoMessage(id: 5, sender: chiara, videoUrl: mondello),
            Parla.newVideoMessage(id: 8, sender: chiara),
            Parla.newTextMessage(id: 6, sender: mainSender, text: "Amazing, i'm coming right now!"),
            Parla.newFileMessage(id: 7, sender: mainSender, url: fileurl)
        ]
        
        
        for m in messages {
            m.options.isBottomLabelActive = false
            m.options.isTopLabelActive = true
            
        }
       
        self.messages.append(contentsOf: [  ])
        // Initialization of ParlaView class
        parlaView.initialize(dataSource: self, delegate: self)
//        // Hide the top label every 4 times.
//        for i in 0 ..< messages.count {
//            messages[i].options.isTopLabelActive = (i % 4 == 0)
//            // messages[i].isTopLabelActive = false
//        }
        
        
        self.collectionView = parlaView.collectionView
    }
    
    
    func didTapMessageBubble(at indexPath: IndexPath, message: PMessage, collectionView: UICollectionView) {
        message.triggerSelection(viewController: self)
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
            let msg = PVideoMessageImpl(id: messages.count+1, sender: outgoingSender(), videoUrl: url)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    func didFinishPickingImage(with image: UIImage?, collectionView: UICollectionView) {
        if image != nil {
            let msg = PImageMessageImpl(id: messages.count+1, sender: outgoingSender(), image: image!)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    func didFinishChoosingFile(atUrl url: URL?) {
        if let u = url {
            let msg = PFileMessageImpl(id: messages.count+1, sender: mainSender, fileName: u.lastPathComponent, url: u)
            messages.append(msg)
            collectionView.reloadData()
            collectionView.scrollToBottom(animated: true)
        }
    }
    
    
    func didStartRecordingVoiceMessage(atUrl url: URL) {
        print("Voice recording  start")
    }
    
    func didEndRecordingVoiceMessage(atUrl url: URL) {
        print("Voice recording  END")
        let msg = PVoiceMessageImpl(id: messages.count+1, sender: outgoingSender(), date: Date(), voiceUrl: url)
        messages.append(msg)
        collectionView.reloadData()
        collectionView.scrollToBottom(animated: true)
    }
    
    
    func didPressAccessoryButton(button: UIView, collectionView: UICollectionView) {
        //Parla.config.accessoryActionChooser?.show()
        print("Did press accessory button")
    }
    
    func outgoingSender() -> POutgoingSender {
        return mainSender
    }
    
    func messageForCell(at indexPath: IndexPath, collectionView: UICollectionView) -> PMessage {
        return self.messages[indexPath.row]
    }
    
    func numberOfMessagesIn(collectionView: UICollectionView) -> Int {
        return self.messages.count
    }
    
}

//PTextMessageImpl(id: 6, sender: domenico, text: "La guerra d'Etiopia, nota anche come guerra d'Abissinia o seconda guerra italo-etiopica, si svolse tra il 3 ottobre 1935 e il 5 maggio 1936 e vide contrapposti il Regno d'Italia e l'Impero d'Etiopia. Condotte inizialmente dal generale Emilio De Bono, rimpiazzato poi dal maresciallo Pietro Badoglio, le forze italiane invasero l'Etiopia a partire dalla colonia eritrea a nord, mentre un fronte secondario fu aperto a sud-est dalle forze del generale Rodolfo Graziani dislocate nella Somalia italiana. Nonostante una dura resistenza, le forze etiopiche furono soverchiate dalla superiorità numerica e tecnologica degli italiani e il conflitto si concluse con l'ingresso delle forze di Badoglio nella capitale Addis Abeba.  La guerra fu la campagna coloniale più grande della storia: la mobilitazione italiana assunse dimensioni straordinarie, impegnando un numero di uomini, una modernità di mezzi e una rapidità di approntamento mai visti fino ad allora. Fu un conflitto altamente simbolico, dove il regime fascista impiegò una grande quantità di mezzi propagandistici con lo scopo di impostare e condurre una guerra in linea con le esigenze di prestigio internazionale e di rinsaldamento interno del regime stesso, volute da Benito Mussolini. In questo contesto i vertici militari e politici italiani non badarono a spese per il raggiungimento dell'obiettivo: il Duce approvò e sollecitò l'invio e l'utilizzo in Etiopia di ogni arma disponibile e non esitò ad autorizzare l'impiego in alcuni casi di armi chimiche."),
//////            PTextMessageImpl(id: 7, sender: chiara, text: "La guerra d'Etiopia, nota anche come guerra d'Abissinia o seconda guerra italo-etiopica, si svolse tra il 3 ottobre 1935 e il 5 maggio 1936 e vide contrapposti il Regno d'Italia e l'Impero d'Etiopia. Condotte inizialmente dal generale Emilio De Bono, rimpiazzato poi dal maresciallo Pietro Badoglio, le forze italiane invasero l'Etiopia a partire dalla colonia eritrea a nord, mentre un fronte secondario fu aperto a sud-est dalle forze del generale Rodolfo Graziani dislocate nella Somalia italiana. Nonostante una dura resistenza, le forze etiopiche furono soverchiate dalla superiorità numerica e tecnologica degli italiani e il conflitto si concluse con l'ingresso delle forze di Badoglio nella capitale Addis Abeba.  La guerra fu la campagna coloniale più grande della storia: la mobilitazione italiana assunse dimensioni straordinarie, impegnando un numero di uomini, una modernità di mezzi e una rapidità di approntamento mai visti fino ad allora. Fu un conflitto altamente simbolico, dove il regime fascista impiegò una grande quantità di mezzi propagandistici con lo scopo di impostare e condurre una guerra in linea con le esigenze di prestigio internazionale e di rinsaldamento interno del regime stesso, volute da Benito Mussolini. In questo contesto i vertici militari e politici italiani non badarono a spese per il raggiungimento dell'obiettivo: il Duce approvò e sollecitò l'invio e l'utilizzo in Etiopia di ogni arma disponibile e non esitò ad autorizzare l'impiego in alcuni casi di armi chimiche. L'aggressione dell'Italia contro l'Etiopia ebbe rilevanti conseguenze diplomatiche e suscitò una notevole riprovazione da parte della comunità internazionale: la Società delle Nazioni decise d'imporre delle sanzioni economiche contro l'Italia, ritirate nel luglio 1936 senza peraltro aver provocato il benché minimo rallentamento delle operazioni militari.  Le ostilità non cessarono con la fine delle operazioni di guerra convenzionali, ma si prolungarono con la crescente attività della guerriglia etiopica dei cosiddetti arbegnuoc (\"patrioti\") e con le conseguenti misure repressive attuate dal governo italiano, durante le quali non furono risparmiate azioni terroristiche nei confronti della popolazione civile; la resistenza etiope collaborò poi con le truppe britanniche nella liberazione del paese dagli italiani nel corso della seconda guerra mondiale. Formalmente lo stato di guerra ebbe ufficialmente termine il 10 febbraio 1947 con la stipula del Trattato di Parigi fra l'Italia e le potenze alleate, che comportò per l'Italia la perdita di tutte le sue colonie africane.  Leggi la voce · Tutte le voci in vetrina    Voci di qualità Voci di qualità Amatori Lodi 1980-1981.jpg L'Amatori Wasken Lodi (IPA: [amaˈtori ˈvasken ˈlɔːdi]; Amatori Hockey Lodi dal 1965 al 1996, Hockey Amatori Sporting Lodi dal 1999 al 2014), meglio noto come Amatori Lodi, è una società italiana di hockey su pista con sede a Lodi. I suoi colori sociali, ispirati allo stemma cittadino, sono il giallo e il rosso.")
//     //   ]
