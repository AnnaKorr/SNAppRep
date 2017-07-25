//
//  SNAppData.swift
//  SNApp
//
//  Created by apple on 25.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class SNAppData: Object {
    dynamic var author: String = ""
    dynamic var title: String = ""
    dynamic var descriptionMy: String = ""
    dynamic var urlToImage: String = ""
    dynamic var url: String = ""
    dynamic var publishedAt: String = ""

}
