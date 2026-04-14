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
		guard let context = context else { return }
		deleteAllMessages(context: context)

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

	func deleteAllMessages(context: NSManagedObjectContext) {
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedMessages.fetchRequest()
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		do {
			try context.execute(deleteRequest)
			try context.save()
		} catch {
			print("Failed to batch delete: \(error)")
		}
	}

	func retrieveFromCD() -> [Message] {
		let request = SavedMessages.fetchRequest()
		return (try? context?.fetch(request).map { $0.convertToMessage() }) ?? []
	}
}
