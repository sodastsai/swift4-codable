//
//  Person.swift
//  Codable
//
//  Created by sodas on 6/6/17.
//  Copyright © 2017 sodastsai. All rights reserved.
//

import Foundation

struct Person: Codable {
    var name: String
    var email: String
    var birthday: Date

    var age: Int {
        let components = Calendar.current.dateComponents([.year],
                                                         from: self.birthday,
                                                         to: Date())
        return components.year!
    }
}
