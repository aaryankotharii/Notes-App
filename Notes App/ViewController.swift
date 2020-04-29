//
//  ViewController.swift
//  Notes App
//
//  Created by Aaryan Kothari on 29/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    var moc : NSManagedObjectContext!
    var entry : NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            moc = appDelegate.persistentContainer.viewContext
        
        if entry != nil{
            self.textView.text = entry.value(forKey: "bodyText") as? String
        } else {
            self.textView.text = ""
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
    }
    
    func createNewEntry(){
        let entryEntity = NSEntityDescription.entity(forEntityName: "Note", in:  moc)!
        
        let entryObject = NSManagedObject(entity: entryEntity, insertInto: moc)
        
        entryObject.setValue(self.textView.text, forKey: "bodyText")
        
        entryObject.setValue(Date(), forKey: "createdAt")
        
        do{
            try moc.save()
        } catch let error as NSError{
            print(error.localizedDescription, "Could not save")
        }
    }


}

