//
//  Messages.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/6/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import Foundation
import CoreData

@Observable
class Messages {
	var messages: [Message] = []
}

class Message: Equatable, Hashable, Identifiable {
	static func == (lhs: Message, rhs: Message) -> Bool {
		lhs.id == rhs.id
	}

	var name: String
	var phone: String
	var email: String
	var message: String
	var id: String

	// Prefer a safe initializer with concrete types
	init(name: String, phone: String, email: String, message: String, id: String) {
		self.name = name
		self.phone = phone
		self.email = email
		self.message = message
		self.id = id
	}

	// Hashable conformance matching Equatable (based on id)
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension SavedMessages {
	func convertToMessage() -> Message {
		Message(
			name: self.name ?? "",
			phone: self.phone ?? "",
			email: self.email ?? "",
			message: self.message ?? "",
			id: self.id ?? ""
		)
	}
}
