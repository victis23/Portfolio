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
	
	func retrieveMessages(handler : @escaping ([Message])->Void) {
		let messageCollection = db.collection(collectionName)
		
		messageCollection.order(by: "timestamp", descending: false)
			.addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
				
				if let error = error {
					print(error.localizedDescription)
					return
				}
				
				guard let response = snapshot else { return }
				
				if !response.metadata.hasPendingWrites && !response.metadata.isFromCache {
					let document = response.documents
					
					let dictionaryArray = document.map { (document) -> Message in
						guard let message = Message(
							name: document["name"] as! String,
							phone: document["phone"] as! String,
							email: document["email"] as! String,
							message: document["message"] as! String,
							id: document.documentID
						) else {
							fatalError()
						}
						return message
					}
					
					handler(dictionaryArray)
				}
			}
	}
	
	func removeMessageFromDB(documentID:String) {
		db.collection(collectionName)
			.document(documentID)
			.delete { (error) in
				
				if let error = error {
					print(error.localizedDescription)
					return
				}
			}
	}
}
