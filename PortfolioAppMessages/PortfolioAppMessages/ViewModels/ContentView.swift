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
	
	func deleteMessageFromDatabase(indexSet:IndexSet) {
		
		//Not an elegant solution but it works.
		defer {
			messageList.messages.removeAll()
		}
		
		if let index = indexSet.first {
			let message = messageList.messages[index]
			firebaseHelper.removeMessageFromDB(documentID: message.id)
		}
	}
	
	func subscribeToTopic() {
		Messaging.messaging()
			.subscribe(toTopic: "/topics/sentMessages") { (error) in
				if let error = error {
					print("Subscription failed with error: \(error.localizedDescription).")
				}
			}
	}
	
	func setNotificationObserver()->String {
		let tokenRetriever = GetGFBToken()
		tokenRetriever.setNotificationObserver()
		let token = tokenRetriever.getTokenString()
		return token
	}
	
	var body: some View {
		NavigationView {
			List {
				ForEach(messageList.messages, id: \Message.message, content: { item in
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
				messages.forEach { item in
					self.messageList.messages.removeAll { value in
						value.message == item.message
					}
					
					self.messageList.messages.append(item)
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
