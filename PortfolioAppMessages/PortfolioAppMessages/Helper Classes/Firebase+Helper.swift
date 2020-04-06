//
//  Firebase+Helper.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/6/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FireBaseHelper {
	
	var db = Firestore.firestore()
	var collectionName : String = "Messages"
	
	func retrieveMessages(handler : @escaping ([Message])->Void){
		
		let messageContainer = Messages()
		
		let messageCollection = db.collection(collectionName)
		
		messageCollection.addSnapshotListener { (snapshot, error) in
			
			if let error = error {
				print(error.localizedDescription)
				return
			}
			
			guard let response = snapshot else {return}
			
			let document = response.documents
			let dictionaryArray = document.map { (document) -> Message? in
				
				let message = Message(name: document["name"] as! String,
										 phone: document["phone"] as! String,
										 email: document["email"] as! String,
										 message: document["message"] as! String)
				return message
			}
			
			dictionaryArray.forEach({ message in
				guard let item = message else {return}
				messageContainer.messages.append(item)
				handler(messageContainer.messages)
			})
		}
	}
	
	func removeMessageFromDB(message: Message){
		db.collection(collectionName)
	}
}
