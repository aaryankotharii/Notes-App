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

class NotesVC: UITableViewController {
    
    var entries : [NSManagedObject]!
    var moc : NSManagedObjectContext!
    
    let database = firebaseNetworking.shared


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Notes Loaded")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        moc = appDelegate.persistentContainer.viewContext
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.fetchEntries()
        print(entries.count,"Numebr of entries")
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
            
            self.entries = entryObjects as? [NSManagedObject]
            
        } catch let error as NSError{
            print("Fetch failed : \(error.localizedDescription)")
        }
        updateDFirebase()
        self.tableView.reloadData()
    }
    
    func updateDFirebase(){
        for entry in entries {
        let bodyText = entry.value(forKey: "bodyText") as? String
        let entryDate = entry.value(forKey: "createdAt") as? Date
        let id = entry.value(forKey: "id") as? String
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let myString = formatter.string(from: entryDate!)
            
            let param = ["bodyText":bodyText,"createdAt":myString] as [String : Any]
            database.AddNote(param: param, id: id!) { (success) in
                if success{
                    print("SUCCESSSS")
                }
            }
        }
    }
    
    
    @IBAction func composeClicked(_ sender: Any) {
        performSegue(withIdentifier: "tonote", sender: nil)
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
        
        let entryDate = entry.value(forKey: "createdAt") as? Date
        
        
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
            self.moc.delete(entry)
            self.entries.remove(at: indexPath.row)
            
                        tableView.deleteRows(at: [indexPath], with: .fade)
            
            do{
                try moc.save()
            }catch{
                print(error.localizedDescription)
            }
           // tableView.reloadData()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
