//
//  Database Manager.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import Firebase

class firebaseNetworking {
    
    //MARK: - variables
    static let shared = firebaseNetworking()
    let database = Database.database().reference()
    let myUID = getUID()
    
    
    //MARK: - Function to fill the user form
    public func AddNote(param: Any,id:String,completion: @escaping (Bool) -> ()) {
        self.database.child("users").child(myUID).child(id).setValue(param) {
            (error:Error?, database:DatabaseReference) in
            if let error = error { // Error Handling
                debugLog(message: "Data could not be saved: \(error).")
                completion(false)
            } else {
                debugLog(message: "Data saved successfully!")
                completion(true)  // Completion handler
            }
        }
    }

    
    //MARK: - Function to update company name
    public func updateNote(bodyText: String, id:String, completion: @escaping (Bool) -> ()) {
        let ref = database.child("users").child(myUID).child(id)
        ref.updateChildValues(["bodyText" : bodyText])
        {
            (error:Error?, database:DatabaseReference) in
            if let error = error { // Error Handling
                debugLog(message: "Data could not be saved: \(error).")
                completion(false)
            } else {
                debugLog(message: "Data saved successfully!")
                completion(true)  // Completion handler
            }
        }
    }


    
}

