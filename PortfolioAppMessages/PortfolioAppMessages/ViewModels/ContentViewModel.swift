//
//  ContentViewModel.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/12/26.
//  Copyright © 2026 DuhMarket. All rights reserved.
//

import Observation
import Foundation

class ContentViewModel: Observable {
	var messageList: Messages = Messages()
	var firebaseHelper = FireBaseHelper()
	
	func onAppear() {
		let token = firebaseHelper.setNotificationObserver()
		self.subscribeToTopic()
		LogHelper.debug("Token has been set: \(token). Notifications now active!")
		
		self.firebaseHelper.retrieveMessages { (messages) in
			messages.forEach({ message in
				if !self.messageList.messages.contains(where: { $0 == message }) {
					self.messageList.messages.append(message)
				}
			})
		}
	}

	func subscribeToTopic() {
		firebaseHelper.subscribeToTopic()
	}

	func deleteMessageFromDatabase(indexSet: IndexSet) {
		guard let index = indexSet.first else { return }

		let message = messageList.messages[index]
		firebaseHelper.deleteMessageFromDatabase(messageID: message.id)
		messageList.messages.removeAll { $0 == message }
	}
}
