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
    
    public func getNotes(completion: @escaping (Bool, [NoteData]) -> ()) {
        print("Get notes called")
        // Variables
        var note = NoteData()
        
        var NoteDataArray = [NoteData]()
        // Observe company child with .childAdded type
        database.child("users").child(myUID).observe(DataEventType.childAdded, with:
            { (snapshot) in
                print(snapshot)
                // Initializing Eumerator
                let enumerator = snapshot.children.allObjects
                // Adding the data from child snapshots
                if let t1 = enumerator[0] as? DataSnapshot { note.bodyText = t1.value as? String }
                if let t2 = enumerator[1] as? DataSnapshot { note.createdAt = t2.value as? String }
                note.id = snapshot.key
                
                NoteDataArray.append(note)  // Appending into companyDataArray
                completion(true, NoteDataArray)  // Completion handler
        }) { (error) in // Error Handling
            debugPrint(error.localizedDescription)
            completion(false, NoteDataArray)
        }
    }
}

struct NoteData{
    var bodyText : String!
    var createdAt : String!
    var id : String!
}

