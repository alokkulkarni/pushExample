//
//  IntentHandler.swift
//  PushNotesSiri
//
//  Created by Alok Kulkarni on 30/01/2019.
//  Copyright © 2019 Alok Kulkarni. All rights reserved.
//

import Intents
import Foundation

class IntentHandler: INExtension, INCreateNoteIntentHandling {
    func handle(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Void) {
            let response = INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.success, userActivity: nil)
            response.createdNote = INNote(title: intent.title!, contents: [], groupName: nil, createdDateComponents: nil, modifiedDateComponents: nil, identifier: nil)
            
            completion(response)
    }
    
    public func confirm(intent: INCreateNoteIntent, completion: @escaping (INCreateNoteIntentResponse) -> Swift.Void) {
        completion(INCreateNoteIntentResponse(code: INCreateNoteIntentResponseCode.ready, userActivity: nil))
    }
    
    public func resolveTitle(forCreateNote intent: INCreateNoteIntent, with completion: @escaping (INStringResolutionResult) -> Swift.Void) {
        let result: INStringResolutionResult
        
        if let title = intent.title?.spokenPhrase, title.count > 0 {
            result = INStringResolutionResult.success(with: title)
        } else {
            result = INStringResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    
    public func resolveContent(for intent: INCreateNoteIntent, with completion: @escaping (INNoteContentResolutionResult) -> Swift.Void) {
        let result: INNoteContentResolutionResult
        
        if let content = intent.content {
            result = INNoteContentResolutionResult.success(with: content)
        } else {
            result = INNoteContentResolutionResult.notRequired()
        }
        
        completion(result)
    }
    
    
    public func resolveGroupName(for intent: INCreateNoteIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Swift.Void) {
        completion(INSpeakableStringResolutionResult.notRequired())
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
