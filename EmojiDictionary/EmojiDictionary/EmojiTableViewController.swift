//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Vidisha Nevatia on 04/06/20.
//  Copyright © 2020 Vidisha Nevatia. All rights reserved.
//

import UIKit

class EmojiTableViewController: UITableViewController {

    var emojis : [Emoji] = []

    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        if let savedEmojis = Emoji.loadFromFile(){
            emojis = savedEmojis
        }
        else{
            emojis = Emoji.loadSampleEmojis()
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    

     override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0
            {
                return emojis.count
            }
            else{
                return 0
            }
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell

            // Configure the cell...
            let emoji = emojis[indexPath.row]
            cell.update(with: emoji)
//            print("\(emoji.symbol) \(indexPath)")
//            cell.textLabel?.text = "\(emoji.symbol) - \(emoji.name)"
//            cell.detailTextLabel?.text = emoji.description
            cell.showsReorderControl = true
            return cell
        }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)  -> UITableViewCell.EditingStyle{
        return .delete
    }
        
   
//    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
//        let tableViewEditingMode = tableView.isEditing
//        tableView.setEditing(!tableViewEditingMode, animated: true)
//    }
    
        /*
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        */

        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                emojis.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                Emoji.saveToFile(emojis: emojis)
                
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
      

      
        // Override to support rearranging the table view.
        override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
            let movedEmoji = emojis.remove(at: fromIndexPath.row)
            emojis.insert(movedEmoji, at: to.row)
            tableView.reloadData()

        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEmoji" {
            let indexPath = tableView.indexPathForSelectedRow!
            let emoji = emojis[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let addEditEmojiTableViewController = navController.topViewController as! AddEditEmojiTableViewController
            
            addEditEmojiTableViewController.emoji = emoji
        }
    }
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue){
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddEditEmojiTableViewController,
            let emoji = sourceViewController.emoji else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        Emoji.saveToFile(emojis: emojis)

    }
   

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
