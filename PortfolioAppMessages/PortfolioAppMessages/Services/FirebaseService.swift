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

class FirebaseService {
	var db = Firestore.firestore()
	var collectionName : String = "Messages"
	var listener: ListenerRegistration?
	
	func retrieveMessages() -> AsyncThrowingStream<[Message], Error> {
		let messageCollection = db.collection(collectionName)
		listener?.remove()
		listener = nil
		
		return AsyncThrowingStream { continuation in
			listener = messageCollection.order(by: "timestamp", descending: false)
				.addSnapshotListener(includeMetadataChanges: false) { (snapshot, error) in
					
					if let error = error {
						print(error.localizedDescription)
						continuation.finish(throwing: error)
					} else if let response = snapshot {
						let document = response.documents
							
						let dictionaryArray = document.compactMap { (document) -> Message? in
							guard let name = document["name"] as? String, let phone = document["phone"] as? String, let email = document["email"] as? String, let message = document["message"] as? String else { return nil }
							
							return Message(
								name: name,
								phone: phone,
								email: email,
								message: message,
								id: document.documentID)
						}
							
						continuation.yield(dictionaryArray)

						continuation.onTermination = { [weak self] _ in
							self?.listener?.remove()
						}
					}
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
		let tokenRetriever = FireBaseTokenService()
		tokenRetriever.setNotificationObserver()

		let token = tokenRetriever.getTokenString()
		LogHelper.debug("Token has been set: \(token). Notifications now active!")

		return token
	}
}
