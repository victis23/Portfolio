//
//  Messages.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/6/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import Foundation

class Messages : ObservableObject {
	@Published var messages : [Message] = []
}

class Message {
	var name : String;
	var phone : String;
	var email : String;
	var message : String;
	var id : String;
	
	init?(name:Any, phone:Any, email:Any, message: Any, id: String){
		self.name = name as! String;
		self.phone = phone as! String;
		self.email = email as! String;
		self.message = message as! String;
		self.id = id;
	}
	
}
