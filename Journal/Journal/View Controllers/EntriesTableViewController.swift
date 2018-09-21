//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Scott Bennett on 9/20/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {
    
    let entryController = EntryController()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        entryController.fetchEntries { (error) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController.entries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else { return UITableViewCell() }
        
        let entry = entryController.entries[indexPath.row]
        
        cell.titleLabel.text = entry.title
        let dateFormatter = DateFormatter()
        cell.timeStampLabel.text = dateFormatter.string(from: entry.timestamp)
        cell.bodyTextLabel.text = entry.bodyText
        

        return cell
    }


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
            tableView.deleteRows(at: [indexPath], with: .fade)
            entryController.entries.remove(at: indexPath.row)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewEntry" {
            guard let destinationVC = segue.destination as? EntryDetailViewController,
                let indexPath =  tableView.indexPathForSelectedRow else { return }
            let entry = entryController.entries[indexPath.row]
            destinationVC.entryController = entryController
            destinationVC.entry = entry
        }
        
        if segue.identifier == "NewEntry" {
            guard let destinationVC = segue.destination as? EntryDetailViewController else { return }
            destinationVC.entryController = entryController
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
