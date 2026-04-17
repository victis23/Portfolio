//
//  TokenRetriever.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/7/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import Foundation

class FireBaseTokenService {
	private var token : String = ""
	
	func setNotificationObserver() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(getToken(notification:)),
			name: Notification.Name("FCMToken"),
			object: nil
		)
	}
	
	@objc func getToken(notification:NSNotification) {
		if let token = notification.userInfo?["token"] as? String {
			
			self.token = token
			print(token)
		}
	}
	
	func getTokenString() -> String {
		token
	}
}
