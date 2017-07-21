//
//  MyData.swift
//  SNApp
//
//  Created by apple on 21.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

class MyData {
    
    let myRealm = try! Realm()

    func loadData() {
        let newDog = Dog()
        newDog.dogAge = 5
        newDog.dogName = "White"
        
        try! myRealm.write {
            myRealm.add(newDog)
            print("My dog \(newDog.dogName) is \(newDog.dogAge) years.")
        }
        
    }
}
