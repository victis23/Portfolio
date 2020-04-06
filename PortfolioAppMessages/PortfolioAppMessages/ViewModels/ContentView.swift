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
	
	var body: some View {
		List {
			ForEach(messageList.messages, id: \Message.message, content: { item in
				VStack{
					Text(item.name)
					Text(item.phone)
					Text(item.email)
					Text(item.message)
				}
			})
		}
		.onAppear {
			let helper = FireBaseHelper()
			
			helper.retrieveMessages { (messages) in
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
