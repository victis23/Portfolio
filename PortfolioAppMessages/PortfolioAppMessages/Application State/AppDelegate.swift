//
//  AppDelegate.swift
//  PortfolioAppMessages
//
//  Created by Scott Leonard on 4/5/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	let notificationCenter = UNUserNotificationCenter.current()
	let fireBaseMessageCenter = Messaging.messaging()
	let gcmMessageIDKey = "gcm.message_id"
	
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()
		
		// Push notification setup
		
		fireBaseMessageCenter.delegate = self
		notificationCenter.delegate = self
		
		let authOptions : UNAuthorizationOptions = [.alert,.badge,.sound]

		notificationCenter.requestAuthorization(options: authOptions) { (hasPassed, error) in

			if let error = error {
				print("Request Authorization for Notification Center failed with error: \(error.localizedDescription)")
			}
			
			DispatchQueue.main.async {
				application.registerForRemoteNotifications()
			}
		}
		
		return true
	}
	
	
	// MARK: UISceneSession Lifecycle
	
	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
	
	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "PortfolioAppMessages")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
}

extension AppDelegate : UNUserNotificationCenterDelegate {
	
	/// Unique device token recieved from APPLE APN upon successful device registration.
	func application(_ application: UIApplication,
					 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		print("This was the registration token recieved: \(deviceToken)...")
	}
	
	///Error message recieved when registration has failed.
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Registratoin to remote APN failed with error : \(error).")
	}
	
	///User information recieved after sucessful APN resigstation.
	func application(_ application: UIApplication,
					 didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		print("UserInfo : \(userInfo)...")
	}
	
	func application(_ application: UIApplication,
					 didReceiveRemoteNotification userInfo: [AnyHashable : Any],
					 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		if let messageID = userInfo[gcmMessageIDKey] {
			
			//Reset icon badge alert count.
			application.applicationIconBadgeNumber = 0
			print("Method with completionHandler Message ID: \(messageID)")
		}
		completionHandler(UIBackgroundFetchResult.newData)
	}
	
}

extension AppDelegate : MessagingDelegate {
	
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
		
		let tokenDict : [String:String] = ["token":fcmToken]
		NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: tokenDict)
		
		print("This is the token recieved for this device! \(fcmToken)")
	}
}
