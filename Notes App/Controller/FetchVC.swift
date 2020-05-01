//
//  FetchVC.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class FetchVC: UIViewController {
    
    var moc : NSManagedObjectContext!
        
    let database = Database.database().reference()
    
    var counter : Int? = nil

    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Fetch view loaded")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        moc = appDelegate.persistentContainer.viewContext
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            getNotes()
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
          let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
          let navController = UINavigationController(rootViewController: vc)
          navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)

    }

    //TODO .value instead of .child added
    
    //MARK:- New Entry
        public func getNotes() {
            print("Get notes called")
            
            let entryEntity = NSEntityDescription.entity(forEntityName: "Note", in:  moc)!
            
            database.child("users").child(getUID()).observe(.childAdded, with:
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

extension Date {
    var stringValue : String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        let string = formatter.string(from: self)
        
        return string
    }
}

extension String {
    var dateValue : Date {
        
        let isoDate = self

        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        let date = dateFormatter.date(from:isoDate) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        
        return finalDate!
    }
}
