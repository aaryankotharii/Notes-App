//
//  LoginVC.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import CoreData

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        deleteAllData(entity: "Note")
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    func deleteAllData(entity: String){

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.returnsObjectsAsFaults = false

    do {
        let arrUsrObj = try managedContext.fetch(fetchRequest)
        for usrObj in arrUsrObj as! [NSManagedObject] {
            managedContext.delete(usrObj)
        }
       try managedContext.save() //don't forget
        } catch let error as NSError {
        print("delete fail--",error)
      }

    }
}
