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
	func onAppear(with context: NSManagedObjectContext?)
	func retrieveMessages()
	func deleteMessageFromDatabase(indexSet: IndexSet)
}

class DefaultContentViewModel: ContentViewModel {
	var messageList: Messages = Messages()
	var firebaseHelper = FireBaseHelper()
	var coreDataHelper: CoreDataHelper?
	
	func onAppear(with context: NSManagedObjectContext? = nil) {
		if let context = context {
			coreDataHelper = MessagesCoredataHelper(context: context)
		}

		_ = firebaseHelper.setNotificationObserver()
		firebaseHelper.subscribeToTopic()
		messageList.messages = retrieveFromCD()
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
	}

	func saveToCoreData(messages: [Message]) {
		let helper = coreDataHelper as? MessagesCoredataHelper
		helper?.saveToCoreData(items: messages)
	}

	func deleteAllMessages() {
		coreDataHelper?.deleteAllMessages()
	}

	func retrieveFromCD() -> [Message] {
		return (coreDataHelper?.retrieveFromCD() as? [Message]) ?? []
	}
}
