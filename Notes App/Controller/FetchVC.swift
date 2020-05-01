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
    
    let database = firebaseNetworking.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Fetch view loaded")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        moc = appDelegate.persistentContainer.viewContext
        createEntries{ (success) in
            print("creating entries")
            if success{
  
            } else {
                print("error in creating entries")
                
            }
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
          let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
          let navController = UINavigationController(rootViewController: vc)
          navController.modalPresentationStyle = .fullScreen
          self.present(navController, animated:true, completion: nil)
    }

    
    //MARK:- New Entry
    func createEntries(completion: @escaping (Bool) -> ()){
        
        print("Creating entries")
        
        let entryEntity = NSEntityDescription.entity(forEntityName: "Note", in:  moc)!
        
        
        database.getNotes { (success, data) in
            print(data.count,"NUMBERRRR")
            if success {

                for note in data {
                    let entryObject = NSManagedObject(entity: entryEntity, insertInto: self.moc)

                    let id = note.id
                    let bodyText = note.bodyText
                    let date = note.createdAt.dateValue
                    
                    entryObject.setValue(bodyText, forKey: "bodyText")
                          
                    entryObject.setValue(date, forKey: "createdAt")
                          
                    entryObject.setValue(id, forKey: "id")
                    
                    //MARK: Save Note in CoreDataBase
                    do{  try self.moc.save() }
                    catch let error as NSError{ print(error.localizedDescription) }
                }
                completion(true)
            }
            else {
                completion(false)
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
