//
//  ContentView.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/5/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseMessaging

struct ContentView: View {
	@ObservedObject var messageList :Messages = Messages()
	private var firebaseHelper = FireBaseHelper()
	
	var body: some View {
		NavigationView {
			List {
				ForEach(messageList.messages, id: \Message.id, content: { item in
					VStack(alignment: .leading){
						Text(item.name)
							.bold()
							.font(.headline)
							.foregroundColor(.blue)
						Text(item.phone)
						Text(item.email)
						Text(item.message)
					}
					.font(.subheadline)
				})
				.onDelete(perform: deleteMessageFromDatabase(indexSet:))
			}
			.navigationBarTitle("Client Messages")
			.navigationViewStyle(StackNavigationViewStyle())
		}
		
		.onAppear {
			print("This is the token: \(Messaging.messaging().fcmToken ?? "No token issued...")")
			
			let token = self.setNotificationObserver()
			self.subscribeToTopic()
			print("This is the returned token: \(token).")
			
			self.firebaseHelper.retrieveMessages { (messages) in
				messages.forEach({ message in
					if !self.messageList.messages.contains(where: { $0 == message }) {
						self.messageList.messages.append(message)
					}
				})
			}
		}
	}
	
	func deleteMessageFromDatabase(indexSet:IndexSet) {
		guard let index = indexSet.first else { return }
			
		let message = messageList.messages[index]
		firebaseHelper.removeMessageFromDB(documentID: message.id)
		messageList.messages.removeAll { $0 == message }
	}
	
	func subscribeToTopic() {
		Messaging.messaging()
			.subscribe(toTopic: "/topics/sentMessages") { (error) in
				if let error = error {
					print("Subscription failed with error: \(error.localizedDescription).")
				}
			}
	}
	
	func setNotificationObserver() -> String {
		let tokenRetriever = GetGFBToken()
		tokenRetriever.setNotificationObserver()
		let token = tokenRetriever.getTokenString()
		return token
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
