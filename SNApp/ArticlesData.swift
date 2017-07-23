//
//  ArticlesData.swift
//  SNApp
//
//  Created by apple on 21.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class ArticlesData: Object {
    dynamic var author: String = ""
    dynamic var title: String = ""
    dynamic var publishedAt: String = ""

}
