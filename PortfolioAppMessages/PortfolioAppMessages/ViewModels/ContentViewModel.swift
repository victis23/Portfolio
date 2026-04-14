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
import UIKit

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
		self.firebaseHelper.retrieveMessages { [weak self] (messages) in
			self?.messageList.messages = messages
			self?.saveToCoreData(messages: messages)
		}
	}

	func deleteMessageFromDatabase(indexSet: IndexSet) {
		guard let index = indexSet.first else { return }

		let message = messageList.messages[index]
		firebaseHelper.deleteMessageFromDatabase(messageID: message.id)
		retrieveMessages()
	}

	func saveToCoreData(messages: [Message]) {
		guard let context = context else { return }

		messages.forEach {
			let coreDataMessages = SavedMessages(context: context)
			coreDataMessages.name = $0.name
			coreDataMessages.email = $0.email
			coreDataMessages.id = $0.id
			coreDataMessages.message = $0.message
			coreDataMessages.phone = $0.phone
		}

		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}
}
