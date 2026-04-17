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
	func onAppear(with context: NSManagedObjectContext?)
	func deleteMessageFromDatabase(indexSet: IndexSet)
	func stopListening()
}

class DefaultContentViewModel: ContentViewModel {
	var messageList: Messages = Messages()
	private var coreDataHelper: (any CoreDataServiceProtocol)?
	private var fireBaseService = FirebaseService()
	private var streamTask: Task<Void,Never>?
	
	func onAppear(with context: NSManagedObjectContext? = nil) {
		if let context = context {
			coreDataHelper = MessagesCoredataService(context: context)
		}

		_ = fireBaseService.setNotificationObserver()
		fireBaseService.subscribeToTopic()
		messageList.messages = retrieveFromCD()
		retrieveMessages()
	}

	private func retrieveMessages() {
		streamTask = Task { [ weak self ] in
			guard let self else { return }
			do {
				for try await messageList in self.fireBaseService.retrieveMessages() {
					self.messageList.messages = messageList
					self.saveToCoreData(messages: messageList)
				}
			} catch {
				print(error)
			}
		}
	}

	func stopListening() {
		streamTask?.cancel()
		streamTask = nil
	}

	func deleteMessageFromDatabase(indexSet: IndexSet) {
		guard let index = indexSet.first else { return }

		let message = messageList.messages[index]
		fireBaseService.deleteMessageFromDatabase(messageID: message.id)
	}

	private func saveToCoreData(messages: [Message]) {
		coreDataHelper?.saveToCoreData(items: messages)
	}

	private func deleteAllMessages() {
		coreDataHelper?.deleteAllMessages()
	}

	private func retrieveFromCD() -> [Message] {
		return (coreDataHelper?.retrieveFromCD() as? [Message]) ?? []
	}
}
