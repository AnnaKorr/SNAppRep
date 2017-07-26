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
import NVHTarGzip

class ViewController: UITableViewController {
    @IBOutlet weak var tblView: UITableView!

    let realmMain = try! Realm()
    let newArt: InfoArraysData = InfoArraysData()
    var myArray = [MyNewRealm]()
    var aaa: [String] = []
    
    
    //работа с очередями:
    let queGoupp = DispatchGroup()
    let concurQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? AnyObject.self)
        
        loadData(data: myArray)
        print("\n ПРОВЕРКА: в массиве \(self.myArray.count) ОБЪЕКТОВ.")
        
        aaa = loadArticlesFromDataBase()
        print("\n ПРОВЕРКА: в массиве \(self.aaa.count) ОБЪЕКТОВ.")

        print(aaa)

        
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 70.0
        
        self.tblView.reloadData()
    }
    
    
    func loadData(data: Array<MyNewRealm>) {

        let myURl = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=6b7c247d75914da0b7a53c8bb951c279"

        Alamofire.request(myURl, method: .get).validate().responseJSON(queue: concurQueue) {
            (myResp) in
            print("\n 1. start \(Thread.current)")
 
            switch myResp.result {
            case .success(let myValue):

                let myJSON = JSON(myValue)

                for (_, subJSON) in myJSON["articles"] {
                let abc = MyNewRealm()
                    abc.author = subJSON["author"].stringValue
                    abc.title = subJSON["title"].stringValue
                    abc.descriptionMy = subJSON["description"].stringValue
                    abc.publishedAt = subJSON["publishedAt"].stringValue
                    abc.url = subJSON["url"].stringValue
                    abc.urlToImage = subJSON["urlToImage"].stringValue
                    self.myArray.append(abc)
                }
                print("\n 2. load \(Thread.current)")
                print("\n ПРОВЕРКА: в массиве ИНФОРМАЦИЯ: \n \(self.myArray).")

                
            case .failure(let error):
                print(error)
            
            }
        }
        
        print("\n 4. return \(Thread.current)")

    }
    
    func writeDB(data: MyNewRealm) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(data, update: true)
        }
        
        print("\n 3. write \(Thread.current)")
        
        print("\n ПРОВЕРКА: в массиве ИНФОРМАЦИЯ: \n \(self.myArray).")
    }
    
    func loadDB(articles: String) -> Results<MyNewRealm> {
        let realm = try! Realm()
        let data = realm.objects(MyNewRealm.self).filter("title BEGINWITH %@", articles)
        
        return data
    }
    
    func loadArticlesFromDataBase() -> [String] {
        let realm = try! Realm()
        var artclsArray: [String] = []
        let data = realm.objects(MyNewRealm.self)
        
        for d in data {
            artclsArray.append(d.title)
        }
        
        try! realm.write {
            realm.add(data, update: true)
        }
        
        print("\n test \(artclsArray)")
        
        return artclsArray
        
    }
    
        
   /*let realmLoadArticles = try! Realm()
        var artclsArray: [String] = []
        let newData = realmLoadArticles.objects(MyNewRealm.self)
        
        for d in newData {
            self.myArray.append(d.articles_name)
            print("Latest news: \(artclsArray.count)")
        }
        
        return artclsArray*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\n oops \(aaa.count)")
        return aaa.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.myTitle?.text = self.aaa[indexPath.row]
        
       /* try! self.realmMain.write {
            self.realmMain.deleteAll()
            print("empty")
        }*/
        
        return cell
    }


}

/* func loadFile() {
 let listNews = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=6b7c247d75914da0b7a53c8bb951c279"
 
 let myPath = NSHomeDirectory() + "/Documents/testfile2Write"
 print("Дома \n\(myPath)")
 let tempPAth = NSTemporaryDirectory()
 print("На работе \n\(tempPAth)")
 
 //создание и запись файла
 do {
 try listNews.write(toFile: myPath, atomically: true, encoding: String.Encoding.utf8)
 print("NOTE: \n***FIle was created")
 } catch let error as NSError {
 print("NOTE: \n***File was not created, the reason is \(error).")
 }
 
 //чтение файла
 var newContent = ""
 do {
 newContent = try NSString(contentsOfFile: myPath, encoding: String.Encoding.utf8.rawValue) as String
 print("NOTE: \n***File content is:\n\(newContent).")
 
 } catch let error as NSError {
 print("NOTE: \n***File content is not readable, the reason is \(error).")
 
 }
 
 //скачивание в файл информации по ссылке
 let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
 Alamofire.download(listNews, to: destination)
 .downloadProgress { progress in
 print("Download Progress: \(progress.fractionCompleted)")
 }
 .responseData { response in
 if response.result.value != nil {
 print("jij \(String(describing: response.destinationURL?.path)) kokok")
 }
 }
 
 }*/

/* func loadDataBase(articleName: String) -> Results<Dog> {
 let realmDB = try! Realm()
 let myData = realmDB.objects(Dog.self).filter("dogName BEGINSWITH %@", articleName)
 
 return myData
 }
 
 func removeInfoFromDB(title: String) {
 let removeRealm = try! Realm()
 let removeData = removeRealm.objects(Dog.self).filter("dogName BEGINSWITH %@", title)
 
 try! removeRealm.write {
 removeRealm.delete(removeData)
 }
 } */


/* func loadArticlesList() -> [DataManager] {
 let realmListArticles = try! Realm()
 var newArticlesList: [DataManager] = []
 let articlesData = realmListArticles.objects(Dog.self)
 
 for da in articlesData {
 let newInfo: DataManager = DataManager()
 newInfo.articleName = da.dogName
 for subDa in da.myList {
 newInfo.authorList.append(subDa.author)
 newInfo.titleList.append(subDa.title)
 }
 newArticlesList.append(newInfo)
 }
 
 print("Hi: \n\(newArticlesList)")
 
 return newArticlesList
 
 }
/*
*/*/

var load: AnyObject? {
    get {
        return UserDefaults.standard.object(forKey: "flag") as AnyObject?
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "flag")
        UserDefaults.standard.synchronize()
    }
}

