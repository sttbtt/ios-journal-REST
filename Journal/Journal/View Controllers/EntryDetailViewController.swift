//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Scott Bennett on 9/20/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            if entry?.title == entry?.title {
                title = entry?.title
                entryTextField.text = entry?.title
                entryTextView.text = entry?.bodyText
            } else {
                title = "Create Entry"
            }
        }
    }
    
   
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = entryTextField.text,
            let bodyText = entryTextView.text else { return }
        
        guard let entry = entry else {
            entryController?.createEntry(title: title, bodyText: bodyText, completion: { (error) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            return }
        
        entryController?.update(entry: entry, title: title, bodyText: bodyText, completion: { (error) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
            
        })
    }
    
   
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
