//
//  CoredataHelper.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/14/26.
//  Copyright © 2026 DuhMarket. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataServiceProtocol<StoredType> {
	associatedtype StoredType
	func saveToCoreData(items: [StoredType])
	func deleteAllMessages()
	func retrieveFromCD() -> [StoredType]
}

class MessagesCoredataService: CoreDataServiceProtocol {
	typealias StoredType = Message
	var context: NSManagedObjectContext

	init(context: NSManagedObjectContext) {
		self.context = context
	}

	func saveToCoreData(items: [Message]) {
		deleteAllMessages()
		
		items.forEach {
			let coreDataMessages = SavedMessages(context: context)
			coreDataMessages.name = $0.name
			coreDataMessages.email = $0.email
			coreDataMessages.id = $0.id
			coreDataMessages.message = $0.message
			coreDataMessages.phone = $0.phone
		}

		saveContext()
	}

	func deleteAllMessages() {
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedMessages.fetchRequest()
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		do {
			try context.execute(deleteRequest)
			saveContext()
		} catch {
			print("Failed to batch delete: \(error)")
		}
	}

	func retrieveFromCD() -> [Message] {
		let request = SavedMessages.fetchRequest()
		return (try? context.fetch(request).map { $0.convertToMessage() }) ?? []
	}

	func saveContext() {
		do {
			try context.save()
		} catch {
			print("Failed to save context change: \(error)")
		}
	}
}
