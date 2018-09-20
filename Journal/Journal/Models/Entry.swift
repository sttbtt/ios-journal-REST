//
//  Entry.swift
//  Journal
//
//  Created by Scott Bennett on 9/20/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import Foundation

struct Entry: Equatable, Codable {
    
    let title: String
    var bodyText: String
    var timestamp: Date
    let identifier: String
    
    init(title: String, bodyText: String, timestamp: Date = Date(), identifier: String = "") {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
}
