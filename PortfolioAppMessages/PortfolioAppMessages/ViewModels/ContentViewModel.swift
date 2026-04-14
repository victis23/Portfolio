//
//  ContentViewModel.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/12/26.
//  Copyright © 2026 DuhMarket. All rights reserved.
//

import Observation
import Foundation
import CoreData

protocol ContentViewModel: Observable {
	var messageList: Messages { get }
	var firebaseHelper: FireBaseHelper { get }
	var context: NSManagedObjectContext? { get set }
	func onAppear(with context: NSManagedObjectContext?)
	func retrieveMessages()
	func deleteMessageFromDatabase(indexSet: IndexSet)
}

class DefaultContentViewModel: ContentViewModel {
	var messageList: Messages = Messages()
	var firebaseHelper = FireBaseHelper()
	var context: NSManagedObjectContext?
	
	func onAppear(with context: NSManagedObjectContext? = nil) {
		_ = firebaseHelper.setNotificationObserver()
		firebaseHelper.subscribeToTopic()
		retrieveMessages()
	}

	func retrieveMessages() {
		self.firebaseHelper.retrieveMessages { (messages) in
			self.messageList.messages = messages
		}
	}

	func deleteMessageFromDatabase(indexSet: IndexSet) {
		guard let index = indexSet.first else { return }

		let message = messageList.messages[index]
		firebaseHelper.deleteMessageFromDatabase(messageID: message.id)
		retrieveMessages()
	}
}
