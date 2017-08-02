//
//  ManagerData.swift
//  SNApp
//
//  Created by apple on 02.08.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON
import NVHTarGzip

private let _labelManager = ManagerData()

class ManagerData {
    let queGoupp = DispatchGroup()
    let concurQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
    var newsArray = [NewsRealm]()
    
    class var singletoneManager: ManagerData {
        return _labelManager
    }
    
    private var _newsRealm: [NewsRealm] = []
    
    var newsRealm: [NewsRealm] {
        var newsRealmCopy: [NewsRealm]!
        concurQueue.sync {
            newsRealmCopy = self._newsRealm
        }
        
        return newsRealmCopy
    }
    
    func loadData(data: Array<NewsRealm>) {
        
        let myURl = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=8e1c098712084f1daae3de518d75e839"
        
        Alamofire.request(myURl, method: .get).validate().responseJSON(queue: self.concurQueue) {
            (myResp) in
            print("\n 1. start \(Thread.current)")
            
            let realm = try! Realm()
            switch myResp.result {
            case .success(let myValue):
                
                
                let myJSON = JSON(myValue)
                
                for (_, subJSON) in myJSON["articles"] {
                    let infoo = NewsRealm()
                    infoo.author = subJSON["author"].stringValue
                    infoo.title = subJSON["title"].stringValue
                    infoo.descriptionMy = subJSON["description"].stringValue
                    infoo.publishedAt = subJSON["publishedAt"].stringValue
                    infoo.url = subJSON["url"].stringValue
                    infoo.urlToImage = subJSON["urlToImage"].stringValue
                    self.newsArray.append(infoo)
                }
                
                try! realm.write {
                    realm.add(self.newsArray, update: true)
                }
                
                print("\n 2. load \(Thread.current)")
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        print("\n 4. return \(Thread.current)")
        
    }
    
    
    func loadArticlesFromDataBase() -> ([String],[String],[String],[String],[String]) {
        let realm = try! Realm()
        var titleDBArray: [String] = []
        var authorsDBArray: [String] = []
        var descriptionsDBArray: [String] = []
        var imagesDBArray: [String] = []
        var urlDBArray: [String] = []
        
        var resultCortege: ([String],[String],[String],[String],[String])
        
        let data = realm.objects(NewsRealm.self)
        
        for value in data {
            titleDBArray.append(value.title)
            authorsDBArray.append(value.author)
            descriptionsDBArray.append(value.descriptionMy)
            imagesDBArray.append(value.urlToImage)
            urlDBArray.append(value.url)
        }
        
        resultCortege.0 = titleDBArray
        resultCortege.1 = authorsDBArray
        resultCortege.2 = descriptionsDBArray
        resultCortege.3 = imagesDBArray
        resultCortege.4 = urlDBArray
        
        try! realm.write {
            realm.add(data, update: true)
        }

        return resultCortege
        
    }
    
}
