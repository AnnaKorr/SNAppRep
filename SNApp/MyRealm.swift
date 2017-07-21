//
//  MyRealm.swift
//  SNApp
//
//  Created by apple on 21.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class Dog: Object {
    dynamic var dogName: String = ""
    dynamic var dogAge: Int = 0
    var myList = List<ArticlesData>()
    
    override static func primaryKey() -> String? {
        return "dogName"
    }
}
