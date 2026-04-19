//
//  ContentView.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/5/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var viewModel: AnyContentViewModel
	@Environment(\.managedObjectContext) var context

	var body: some View {
		NavigationStack {
			List {
				ForEach(viewModel.messageList.messages, content: { item in
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
				.onDelete(perform: viewModel.deleteMessageFromDatabase(indexSet:))
			}
			.navigationBarTitle("Client Messages")
		}
		
		.onAppear {
			viewModel.onAppear(with: context)
		}
		.onDisappear {
			viewModel.stopListening()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
