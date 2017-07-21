//
//  ViewController.swift
//  SNApp
//
//  Created by apple on 21.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class ViewController: UITableViewController {
    @IBOutlet weak var tblView: UITableView!

    let myRealm = try! Realm()
    let myURl = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=6b7c247d75914da0b7a53c8bb951c279"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        loadData()
        let aaa = loadArticlesFromDataBase()
        print("Hello \(aaa)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        Alamofire.request(myURl, method: .get).validate().responseJSON { (myResp) in
            
            switch myResp.result {
            case .success(let myValue):
                let myJSON = JSON(myValue)
                let newDog = Dog()
                newDog.dogAge = 5
                newDog.dogName = myJSON["articles"][0]["title"].stringValue
                
                for (_, subJSON) in myJSON["articles"] {
                    let aaa = ArticlesData()
                    aaa.author = subJSON["author"].stringValue
                    aaa.title = subJSON["title"].stringValue
                    newDog.myList.append(aaa)
                    
                }
                
                print(newDog)
        
                try! self.myRealm.write {
                    self.myRealm.add(newDog, update: true)
                    print("My dog \(newDog.dogName) is \(newDog.dogAge) years.")
                }
            case .failure(let error):
                print(error)
            
            }
        
            
        }
        
        
    }
    
    func loadDataBase(newArticles: String) -> Results<Dog> {
        let myRealm = try! Realm()
        let myData = myRealm.objects(Dog.self).filter("dogName BEGINSWITH %@", newArticles)
        
        return myData
    }
    
    func loadArticlesFromDataBase() -> [String] {
        let myRealm = try! Realm()
        var artclsArray: [String] = []
        let newData = myRealm.objects(Dog.self)
        
        for d in newData {
            artclsArray.append(d.dogName)
            print("Latest news: \(artclsArray)")
        }
        
        return artclsArray
    }
    
    var load: AnyObject? {
        get {
            return UserDefaults.standard.object(forKey: "flag") as AnyObject?
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "flag")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadArticlesFromDataBase().count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = loadArticlesFromDataBase()[indexPath.row]
        return cell
        
    }


}

