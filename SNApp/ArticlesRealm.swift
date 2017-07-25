//
//  ArticlesRealm.swift
//  SNApp
//
//  Created by apple on 25.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import Foundation
import RealmSwift


class ArticlesRealm: Object {
    dynamic var articles_name: String = ""
    var myList = List<ArticlesData>()
    
    override static func primaryKey() -> String? {
        return "articles_name"
    }
}
