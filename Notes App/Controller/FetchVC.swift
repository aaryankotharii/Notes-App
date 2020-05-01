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
    
    var entries : [NSManagedObject]!
       var moc : NSManagedObjectContext!
    
    let database = firebaseNetworking.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        moc = appDelegate.persistentContainer.viewContext
        self.fetchEntries()
    }
    
    
    func fetchEntries(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let entryObjects = try moc.fetch(fetchRequest)
            self.entries = entryObjects as? [NSManagedObject]
        } catch let error as NSError{
            print("Fetch failed : \(error.localizedDescription)")
        }
    }
    
    func updateDFirebase(){
        for entry in entries {
        let bodyText = entry.value(forKey: "bodyText") as? String
        let entryDate = entry.value(forKey: "createdAt") as? Date
        let id = entry.value(forKey: "id") as? String

            
            let param = ["bodyText":bodyText,"createdAt":entryDate?.stringValue] as [String : Any]
            database.AddNote(param: param, id: id!) { (success) in
                if success{
                    print("SUCCESSSS")
                }
            }
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
