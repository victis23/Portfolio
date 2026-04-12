//
//  Firebase+Helper.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/6/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseMessaging

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
						return Message(
							name: document["name"] as! String,
							phone: document["phone"] as! String,
							email: document["email"] as! String,
							message: document["message"] as! String,
							id: document.documentID)
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

	func subscribeToTopic() {
		defer {
			LogHelper.debug("This is the token: \(Messaging.messaging().fcmToken ?? "No token issued...")")
		}

		Messaging.messaging()
			.subscribe(toTopic: "/topics/sentMessages") { (error) in
				if let error = error {
					LogHelper.error("Subscription failed with error: \(error.localizedDescription).")
				}
			}
	}

	func deleteMessageFromDatabase(messageID: String) {
		removeMessageFromDB(documentID: messageID)
	}

	func setNotificationObserver() -> String {
		let tokenRetriever = GetGFBToken()
		tokenRetriever.setNotificationObserver()
		let token = tokenRetriever.getTokenString()
		return token
	}
}
