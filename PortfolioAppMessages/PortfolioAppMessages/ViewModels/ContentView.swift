//
//  ContentView.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/5/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	@ObservedObject var messageList :Messages = Messages()
	private var firebaseHelper = FireBaseHelper()
	
	func deleteMessageFromDatabase(indexSet:IndexSet){
		
		defer {
			messageList.messages.remove(atOffsets: indexSet)
		}
		
		if let index = indexSet.first {
			
			let message = messageList.messages[index]
			firebaseHelper.removeMessageFromDB(documentID: message.id)
		}
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
		}
			
		.onAppear {
			
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
