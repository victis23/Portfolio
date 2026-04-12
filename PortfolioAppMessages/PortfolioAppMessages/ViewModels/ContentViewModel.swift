//
//  ContentViewModel.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/12/26.
//  Copyright © 2026 DuhMarket. All rights reserved.
//

import Observation
import Foundation

protocol ContentViewModel: Observable {
	var messageList: Messages { get }
	var firebaseHelper: FireBaseHelper { get }
	func onAppear()
	func retrieveMessages()
	func deleteMessageFromDatabase(indexSet: IndexSet)
}

class DefaultContentViewModel: ContentViewModel {
	var messageList: Messages = Messages()
	var firebaseHelper = FireBaseHelper()
	
	func onAppear() {
		_ = firebaseHelper.setNotificationObserver()
		firebaseHelper.subscribeToTopic()
		retrieveMessages()
	}

	func retrieveMessages() {
		self.firebaseHelper.retrieveMessages { (messages) in
			messages.forEach({ message in
				if !self.messageList.messages.contains(where: { $0 == message }) {
					self.messageList.messages.append(message)
				}
			})
		}
	}

	func deleteMessageFromDatabase(indexSet: IndexSet) {
		guard let index = indexSet.first else { return }

		let message = messageList.messages[index]
		firebaseHelper.deleteMessageFromDatabase(messageID: message.id)
		messageList.messages.removeAll { $0 == message }
	}
}
