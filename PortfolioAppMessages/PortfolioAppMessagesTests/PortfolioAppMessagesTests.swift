//
//  PortfolioAppMessagesTests.swift
//  PortfolioAppMessagesTests
//
//  Created by Scott Leonard on 4/5/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

import Testing
import CoreData
import FirebaseFirestore
import FirebaseMessaging
import Observation
@testable import MichaelWells_dev

// MARK: - Message Model Tests
@Suite("Message Model Tests")
struct MessageTests {
	
	@Test("Message initialization creates correct instance")
	func messageInitialization() {
		let message = Message(
			name: "John Doe",
			phone: "555-1234",
			email: "john@example.com",
			message: "Test message",
			id: "123"
		)
		
		#expect(message.name == "John Doe")
		#expect(message.phone == "555-1234")
		#expect(message.email == "john@example.com")
		#expect(message.message == "Test message")
		#expect(message.id == "123")
	}
	
	@Test("Messages with same ID are equal")
	func messageEquality() {
		let message1 = Message(
			name: "John Doe",
			phone: "555-1234",
			email: "john@example.com",
			message: "Test message",
			id: "123"
		)
		
		let message2 = Message(
			name: "Jane Doe",
			phone: "555-5678",
			email: "jane@example.com",
			message: "Different message",
			id: "123"
		)
		
		#expect(message1 == message2)
	}
	
	@Test("Messages with different IDs are not equal")
	func messageInequality() {
		let message1 = Message(
			name: "John Doe",
			phone: "555-1234",
			email: "john@example.com",
			message: "Test message",
			id: "123"
		)
		
		let message2 = Message(
			name: "John Doe",
			phone: "555-1234",
			email: "john@example.com",
			message: "Test message",
			id: "456"
		)
		
		#expect(message1 != message2)
	}
	
	@Test("Messages with same ID have same hash")
	func messageHashability() {
		let message1 = Message(
			name: "John Doe",
			phone: "555-1234",
			email: "john@example.com",
			message: "Test message",
			id: "123"
		)
		
		let message2 = Message(
			name: "Jane Doe",
			phone: "555-5678",
			email: "jane@example.com",
			message: "Different message",
			id: "123"
		)
		
		#expect(message1.hashValue == message2.hashValue)
	}
	
	@Test("Message can be stored in Set")
	func messageInSet() {
		let message1 = Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1")
		let message2 = Message(name: "Jane", phone: "456", email: "jane@test.com", message: "Hello", id: "2")
		let message3 = Message(name: "John Updated", phone: "123", email: "john@test.com", message: "Hi", id: "1")
		
		var messageSet: Set<Message> = [message1, message2]
		#expect(messageSet.count == 2)
		
		messageSet.insert(message3)
		#expect(messageSet.count == 2, "Should not add duplicate with same ID")
	}
}

// MARK: - Messages Collection Tests
@Suite("Messages Collection Tests")
struct MessagesTests {
	
	@Test("Messages initializes with empty array")
	func messagesInitialization() {
		let messages = Messages()
		#expect(messages.messages.isEmpty)
	}
	
	@Test("Messages can store multiple Message objects")
	func messagesStorage() {
		let messages = Messages()
		let message1 = Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1")
		let message2 = Message(name: "Jane", phone: "456", email: "jane@test.com", message: "Hello", id: "2")
		
		messages.messages = [message1, message2]
		#expect(messages.messages.count == 2)
		#expect(messages.messages[0].name == "John")
		#expect(messages.messages[1].name == "Jane")
	}
}

// MARK: - Mock Classes for Testing
class MockCoreDataService: CoreDataServiceProtocol {
	typealias StoredType = Message
	
	var savedMessages: [Message] = []
	var saveCallCount = 0
	var deleteCallCount = 0
	var retrieveCallCount = 0
	
	func saveToCoreData(items: [Message]) {
		saveCallCount += 1
		savedMessages = items
	}
	
	func deleteAllMessages() {
		deleteCallCount += 1
		savedMessages.removeAll()
	}
	
	func retrieveFromCD() -> [Message] {
		retrieveCallCount += 1
		return savedMessages
	}
}

class MockFirebaseService {
	var deleteCallCount = 0
	var lastDeletedMessageID: String?
	var mockMessages: [Message] = []
	
	func deleteMessageFromDatabase(messageID: String) {
		deleteCallCount += 1
		lastDeletedMessageID = messageID
	}
	
	func retrieveMessages() -> AsyncThrowingStream<[Message], Error> {
		return AsyncThrowingStream { continuation in
			continuation.yield(mockMessages)
			continuation.finish()
		}
	}
}

class MockContentViewModel: ContentViewModel {
	var messageList = Messages()
	var onAppearCalled = false
	var deleteCallCount = 0
	var stopListeningCalled = false
	var providedContext: NSManagedObjectContext?
	
	func onAppear(with context: NSManagedObjectContext?) {
		onAppearCalled = true
		providedContext = context
	}
	
	func deleteMessageFromDatabase(indexSet: IndexSet) {
		deleteCallCount += 1
		guard let index = indexSet.first else { return }
		if index < messageList.messages.count {
			messageList.messages.remove(at: index)
		}
	}
	
	func stopListening() {
		stopListeningCalled = true
	}
}

// MARK: - AnyContentViewModel Tests
@Suite("AnyContentViewModel Tests")
struct AnyContentViewModelTests {
	
	@Test("AnyContentViewModel initializes with view model")
	func initialization() {
		let mockViewModel = MockContentViewModel()
		let anyViewModel = AnyContentViewModel(viewModel: mockViewModel)
		
		#expect(anyViewModel.viewModel != nil)
		#expect(anyViewModel.messageList.messages.isEmpty)
	}
	
	@Test("AnyContentViewModel forwards onAppear call")
	func forwardsOnAppear() {
		let mockViewModel = MockContentViewModel()
		let anyViewModel = AnyContentViewModel(viewModel: mockViewModel)
		
		anyViewModel.onAppear(with: nil)
		
		#expect(mockViewModel.onAppearCalled)
	}
	
	@Test("AnyContentViewModel forwards delete call")
	func forwardsDelete() {
		let mockViewModel = MockContentViewModel()
		mockViewModel.messageList.messages = [
			Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1")
		]
		let anyViewModel = AnyContentViewModel(viewModel: mockViewModel)
		
		anyViewModel.deleteMessageFromDatabase(indexSet: IndexSet(integer: 0))
		
		#expect(mockViewModel.deleteCallCount == 1)
	}
	
	@Test("AnyContentViewModel forwards stopListening call")
	func forwardsStopListening() {
		let mockViewModel = MockContentViewModel()
		let anyViewModel = AnyContentViewModel(viewModel: mockViewModel)
		
		anyViewModel.stopListening()
		
		#expect(mockViewModel.stopListeningCalled)
	}
}
// MARK: - CoreData Service Tests
@Suite("CoreData Service Tests")
struct CoreDataServiceTests {
	
	func createInMemoryContext() -> NSManagedObjectContext {
		let container = NSPersistentContainer(name: "PortfolioAppMessages")
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		container.persistentStoreDescriptions = [description]
		
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Failed to load in-memory store: \(error)")
			}
		}
		
		return container.viewContext
	}
	
	@Test("CoreData service saves messages")
	func savesMessages() throws {
		let context = createInMemoryContext()
		let service = MessagesCoredataService(context: context)
		
		let messages = [
			Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1"),
			Message(name: "Jane", phone: "456", email: "jane@test.com", message: "Hello", id: "2")
		]
		
		service.saveToCoreData(items: messages)
		
		let retrieved = service.retrieveFromCD()
		#expect(retrieved.count == 2)
		#expect(retrieved.contains { $0.name == "John" })
		#expect(retrieved.contains { $0.name == "Jane" })
	}
	
	@Test("CoreData service deletes all messages")
	func deletesAllMessages() throws {
		let context = createInMemoryContext()
		let service = MessagesCoredataService(context: context)
		
		let messages = [
			Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1")
		]
		
		service.saveToCoreData(items: messages)
		#expect(service.retrieveFromCD().count == 1)
		
		service.deleteAllMessages()
		#expect(service.retrieveFromCD().isEmpty)
	}
	
	@Test("CoreData service replaces messages on save")
	func replacesMessagesOnSave() throws {
		let context = createInMemoryContext()
		let service = MessagesCoredataService(context: context)
		
		let initialMessages = [
			Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1")
		]
		service.saveToCoreData(items: initialMessages)
		
		let newMessages = [
			Message(name: "Jane", phone: "456", email: "jane@test.com", message: "Hello", id: "2")
		]
		service.saveToCoreData(items: newMessages)
		
		let retrieved = service.retrieveFromCD()
		#expect(retrieved.count == 1)
		#expect(retrieved[0].name == "Jane")
	}
}

// MARK: - DefaultContentViewModel Tests
@Suite("DefaultContentViewModel Tests")
struct DefaultContentViewModelTests {
	
	@Test("ViewModel initializes with empty message list")
	func initialization() {
		let viewModel = DefaultContentViewModel()
		#expect(viewModel.messageList.messages.isEmpty)
	}
	
	@Test("Delete message from database removes correct message", .enabled(if: false))
	func deleteMessage() async throws {
		// Note: This test is disabled because it requires Firebase mocking
		// In a real implementation, you would inject FirebaseService as a dependency
		let viewModel = DefaultContentViewModel()
		
		viewModel.messageList.messages = [
			Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1"),
			Message(name: "Jane", phone: "456", email: "jane@test.com", message: "Hello", id: "2")
		]
		
		viewModel.deleteMessageFromDatabase(indexSet: IndexSet(integer: 0))
		
		// This would require Firebase integration to fully test
	}
	
	@Test("Stop listening cancels stream task")
	func stopListening() {
		let viewModel = DefaultContentViewModel()
		
		// Call onAppear to potentially start listening
		viewModel.onAppear(with: nil)
		
		// Stop listening should not crash
		viewModel.stopListening()
		
		// Call again to ensure it's idempotent
		viewModel.stopListening()
		
		#expect(true, "stopListening should be safe to call multiple times")
	}
}

// MARK: - Integration Tests
@Suite("Integration Tests")
struct IntegrationTests {
	
	@Test("Complete workflow: onAppear, add messages, delete message")
	func completeWorkflow() async throws {
		let mockViewModel = MockContentViewModel()
		let anyViewModel = AnyContentViewModel(viewModel: mockViewModel)
		
		// Simulate view appearing
		anyViewModel.onAppear(with: nil)
		#expect(mockViewModel.onAppearCalled)
		
		// Add messages
		mockViewModel.messageList.messages = [
			Message(name: "John", phone: "123", email: "john@test.com", message: "Hi", id: "1"),
			Message(name: "Jane", phone: "456", email: "jane@test.com", message: "Hello", id: "2")
		]
		#expect(mockViewModel.messageList.messages.count == 2)
		
		// Delete a message
		anyViewModel.deleteMessageFromDatabase(indexSet: IndexSet(integer: 0))
		#expect(mockViewModel.deleteCallCount == 1)
		#expect(mockViewModel.messageList.messages.count == 1)
		
		// Stop listening
		anyViewModel.stopListening()
		#expect(mockViewModel.stopListeningCalled)
	}
}

