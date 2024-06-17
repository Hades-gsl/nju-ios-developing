//
//  MyTableViewController.swift
//  Calcudoku Collection App
//
//  Created by gsy on 2023/11/11.
//

import UIKit

class MyTableViewController: UITableViewController {

    let kv: [Int:String] = [
        0: "Beginner",
        1: "Easy",
        2: "Med",
        3: "Hard",
        4: "Mixed",
        5: "No-op",
    ]
    
    let kv2: [String:String] = [
        "Beginner" : "0",
        "Easy" : "1",
        "Med" : "2",
        "Hard" : "3",
        "Mixed" : "4",
        "No-op" : "5",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 20
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath)

        var content = cell.defaultContentConfiguration()
        var s = String(indexPath.section + 1)
        if s.count < 2{
            s = "0" + s
        }
        content.text = "\(kv[indexPath.row]!) \(s)"
        cell.contentConfiguration = content

        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier != "id1"{
            return
        }
        
        let d = segue.destination as! SecondTableViewController
        let cell = sender as! UITableViewCell
        
        let t1 = self.title!
        d.u = String(t1[t1.startIndex])
        
        let content = cell.contentConfiguration as! UIListContentConfiguration
        let t2 = content.text!
        let index = t2.firstIndex(of: " ")!
        d.u += kv2[String(t2[..<index])]!
        
        d.u += String(t2[t2.index(after: index)..<t2.endIndex])
    }
    

}
