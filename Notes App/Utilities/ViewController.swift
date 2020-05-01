//
//  ViewController.swift
//  Notes App
//
//  Created by Aaryan Kothari on 29/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    var moc : NSManagedObjectContext!
    var entry : NSManagedObject!
    var id : String!
    
    let database = firebaseNetworking.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        moc = appDelegate.persistentContainer.viewContext
        
        if entry != nil{
            self.textView.text = entry.value(forKey: "bodyText") as? String
            id = entry.value(forKey: "id") as? String
        } else {
            self.textView.text = ""
        }
    }


        
    
    override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
        if entry != nil{
                self.updateEntry()
            } else {
                if textView.text != nil{
                    self.createNewEntry()
                    print("New entry made")
                }
            }
    }
    
    func updateEntry(){
        
        //MARK:
        entry.setValue(self.textView.text, forKey: "bodyText")
        entry.setValue(Date(), forKey: "createdAt")
        
        do{  try moc.save() }
        catch { print(error.localizedDescription)  }
        
        //MARK:
        database.updateNote(bodyText: textView.text, id: id) { (success) in
            if success {
                print("NOTES UPDATED")
            }
        }
    }
    
  
    //MARK:- New Entry
    func createNewEntry(){
       let entryEntity = NSEntityDescription.entity(forEntityName: "Note", in:  moc)!

       let id = NSUUID().uuidString

        let entryObject = NSManagedObject(entity: entryEntity, insertInto: moc)

        entryObject.setValue(self.textView.text, forKey: "bodyText")

        entryObject.setValue(Date(), forKey: "createdAt")

        entryObject.setValue(id, forKey: "id")

        //MARK: Save Note in CoreDataBase
        do{  try moc.save() }
        catch let error as NSError{ print(error.localizedDescription) }

        
        //MARK: Save Note in Firebase Database
        let param = ["bodyText":textView.text!,"createdAt":Date().stringValue] as [String : String]
        
        database.AddNote(param: param, id: id) { (success) in
                if success{
                    print("SUCCESSSS added to database")
                }
            }
        }
}

extension ViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if entry != nil {
        database.updateNote(bodyText: textView.text, id: id) { (success) in
            if success {
                print("NOTES UPDATED")
            }
        }
        }
    }
}

