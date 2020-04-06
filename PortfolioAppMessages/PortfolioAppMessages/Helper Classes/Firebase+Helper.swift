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
	
	
	func get(){
		let db = Firestore.firestore()
		
		let messageList = Messages()
		db.collection("Messages").getDocuments { (snapshot, error) in
			
			if let items = snapshot?.documents{
				
				items.forEach { item in
					
					if let message = Message(name: item.data()["name"] as! String,
											 phone: item.data()["phone"] as! String,
											 email: item.data()["email"] as! String,
											 message: item.data()["message"] as! String) {
						messageList.messages.append(message)
					}
					messageList.messages.forEach{ message in
						print(message.name)
					}
				}
			}
		}
	}
}
