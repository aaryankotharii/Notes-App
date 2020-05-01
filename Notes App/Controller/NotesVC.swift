//
//  NotesVC.swift
//  Notes App
//
//  Created by Aaryan Kothari on 29/04/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn

class NotesVC: UITableViewController {
    
    var entries = [NSManagedObject]()
    var moc : NSManagedObjectContext!
    
    let database = firebaseNetworking.shared

    @IBAction func deleteAll(_ sender: Any) {
        deleteAllData(entity: "Note")
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Notes Loaded")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        moc = appDelegate.persistentContainer.viewContext
         //self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.fetchEntries()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchEntries()
        print(entries.count,"Numebr of entries")
    }
    
    
    
    func fetchEntries(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let entryObjects = try moc.fetch(fetchRequest)
            
            self.entries = (entryObjects as? [NSManagedObject])!
            
        } catch let error as NSError{
            print("Fetch failed : \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
        
    
    @IBAction func composeClicked(_ sender: Any) {
        performSegue(withIdentifier: "tonote", sender: nil)
    }
    
    
    @IBAction func signOutClikced(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        UserDefaults.standard.setValue(false, forKey: "login")
        deleteAllData(entity: "Note")
        for entry in entries {
            self.moc.delete(entry)
        }
            do{
                try moc.save()
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let VC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.present(VC, animated: true, completion: nil)

            }catch{
                print(error.localizedDescription)
            }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notescell", for: indexPath) as! NotesTableViewCell
        
        let entry = entries[indexPath.row]
        
        cell.titleLabel.text = entry.value(forKey: "bodyText") as? String
        
        //let entryDate = entry.value(forKey: "createdAt") as? Date
        
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let entry = self.entries[indexPath.row]
        
        self.performSegue(withIdentifier: "tonote", sender: entry)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tonote"{
            let vc = segue.destination as! ViewController
            
            vc.entry = sender as? NSManagedObject
            
            
            
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source

            
            let entry = entries[indexPath.row]
            let id = entry.value(forKey: "id") as? String
            self.moc.delete(entry)
            self.entries.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do{
                try moc.save()
            }catch{
                print(error.localizedDescription)
            }
                        
            database.deleteNote(id!)
        }
    }
    
}
