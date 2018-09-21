//
//  EntryController.swift
//  Journal
//
//  Created by Scott Bennett on 9/20/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation

class EntryController {
    
    var entries: [Entry] = []
    let baseURL = URL(string: "https://journal-810d6.firebaseio.com/")!
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void) {
        
        var requestURL = baseURL.appendingPathComponent(entry.identifier)
        requestURL.appendPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(entry)
        } catch {
            NSLog("Error encoding data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error with the dataTask \(error)")
                completion(error)
                return
            }
            
            self.entries.append(entry)
            completion(nil)
        }.resume()
    }
    
    func createEntry(title: String, bodyText: String, completion: @escaping (Error?) -> Void) {
        
        let entry = Entry(title: title, bodyText: bodyText)
        put(entry: entry) { (error) in
            completion(nil)
        }
        
    }
    
    func update(entry: Entry, title: String, bodyText: String, completion: @escaping (Error?) -> Void) {
        
        guard let index = entries.index(of: entry) else { return }
        let newEntry = Entry(title: title, bodyText: bodyText)
        entries.remove(at: index)
        entries.insert(newEntry, at: index)
        put(entry: entry) { (error) in
            completion(nil)
        }
        
    }
    
    func fetchEntries(completion: @escaping (Error?) -> Void) {
        
        var requestURL = baseURL
        requestURL.appendPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        print(request)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error with the dataTask: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from dataTask.")
                completion(error)
                return
            }
            
            do {
                let entryResults = try JSONDecoder().decode([String: Entry].self, from: data)
                let results = entryResults.map({$0.value })
                let sortedEntries = results.sorted(by: { (entry1, entry2) -> Bool in
                    return entry1.timestamp > entry2.timestamp
                })
                self.entries = sortedEntries
                completion(nil)
            } catch {
                NSLog("Unable to decode data into Entry \(error)")
                completion(error)
                return
            }
            
        }.resume()
    }
    
}
