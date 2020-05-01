//
//  Database Manager.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class firebaseNetworking {
    
    
    //MARK: - variables
    static let shared = firebaseNetworking()
    let database = Database.database().reference().child("users").child(getUID())
    let myUID = getUID()
    var moc : NSManagedObjectContext!

    
    
    deinit {
        // remove all observer to free memory
        self.database.removeAllObservers()
    }
    
    
    //MARK: - Function to add user
    public func AddNote(param: Any,id:String,completion: @escaping (Bool) -> ()) {
        self.database.child(id).setValue(param) {
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

    
    //MARK: - Function to update Note
    public func updateNote(bodyText: String, id:String, completion: @escaping (Bool) -> ()) {
        let ref = database.child(id)
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
    
    public func deleteNote(_ id : String){
        let ref = database.child(id)
        ref.removeValue()
    }
    
    public func getNotes() {
          print("Get notes called")
          
        
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            moc = appDelegate.persistentContainer.viewContext
        
          let entryEntity = NSEntityDescription.entity(forEntityName: "Note", in:  moc)!
          
          
        database.observe(.childAdded ,with:
              { (snapshot) in
                  print(snapshot)
                  
                  // Initializing Eumerator
                  let enumerator = snapshot.children.allObjects
                  var bodyText = ""
                  var createdAt = ""
                  // Adding the data from child snapshots
                  if let t1 = enumerator[0] as? DataSnapshot { bodyText = (t1.value as? String)!
                  }
                  
                  if let t2 = enumerator[1] as? DataSnapshot { createdAt = (t2.value as? String)! }
                  
                  let id = snapshot.key
                  
                  print("Creating entries")

                  let entryObject = NSManagedObject(entity: entryEntity, insertInto: self.moc)

                  entryObject.setValue(bodyText, forKey: "bodyText")

                  entryObject.setValue(createdAt.dateValue, forKey: "createdAt")

                  entryObject.setValue(id, forKey: "id")

                  //MARK: Save Note in CoreDataBase
                  do{  try self.moc.save() }
                  catch let error as NSError{ print(error.localizedDescription) }
                  
          }
          ) { (error) in // Error Handling
              debugPrint(error.localizedDescription)
          }
      }
}
