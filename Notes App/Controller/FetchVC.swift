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
    
        
  //  let database = Database.database().reference()
    
    let database = firebaseNetworking.shared
    
    var counter : Int? = nil

    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Fetch view loaded")
    
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        database.getNotes()
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
          let vc = storyboard.instantiateViewController(withIdentifier: "NotesVC") as! NotesVC
          let navController = UINavigationController(rootViewController: vc)
          navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated:true, completion: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Fetch IS ABOUT TO DISSAPPEAR")
    }

    //TODO .value instead of .child added
    
    //MARK:- New Entry
  
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
