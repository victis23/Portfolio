//
//  ContentView.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/5/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State var viewModel: ContentViewModel = DefaultContentViewModel()
	@Environment(\.managedObjectContext) var context

	var body: some View {
		NavigationView {
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
			.navigationViewStyle(StackNavigationViewStyle())
		}
		
		.onAppear {
			viewModel.onAppear(with: context)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
