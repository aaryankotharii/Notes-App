//
//  Constants.swift
//  Notes App
//
//  Created by Aaryan Kothari on 01/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation
import Firebase
import CoreData


//MARK: -  function to get uid
internal func getUID() -> String {
    let uid = Auth.auth().currentUser?.uid
    return uid ?? "notFound"
}

public func debugLog(message: String) {
    #if DEBUG
    debugPrint("=======================================")
    debugPrint(message)
    debugPrint("=======================================")
    #endif
}

public func deleteAllData(entity: String){

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
