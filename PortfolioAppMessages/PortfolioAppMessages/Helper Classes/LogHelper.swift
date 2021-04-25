//
//  LogHelper.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/25/21.
//  Copyright © 2021 DuhMarket. All rights reserved.
//

import Foundation
import os

class LogHelper {
	private static var logger = Logger()
	
	private init() { }
	
	static func debug(_ message: String) {
		logger.debug("[DEBUG] - \(message)")
	}
	
	static func error(_ message: String) {
		logger.critical("[ERROR] - \(message)")
	}
	
	static func info(_ message: String) {
		logger.info("[LOG] - \(message)")
	}
}
