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

    let myURl = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=6b7c247d75914da0b7a53c8bb951c279"
    let realmMain = try! Realm()
    let newArt: InfoArraysData = InfoArraysData()
    //var classCityList: [String] = []
    var myArray = [MyNewRealm]()


    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? AnyObject.self)
        
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 70.0
        
        loadData()
       // let classCityList = loadArticlesFromDataBase(data: MyNewRealm)
        print("ПРОВЕРКА СВЯЗИ: в массиве \(self.myArray.count) объектов")
        
        self.tblView.reloadData()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() -> [MyNewRealm] {
        let myRealm = try! Realm()

        Alamofire.request(myURl, method: .get).validate().responseJSON { (myResp) in
 
            switch myResp.result {
            case .success(let myValue):
                let myJSON = JSON(myValue)
                //let info = InfoListRealm()
                //info.articles_name = myJSON["articles"][0]["title"].stringValue

                for (_, subJSON) in myJSON["articles"] {
                    let abc = MyNewRealm()
                    abc.author = subJSON["author"].stringValue
                    abc.title = subJSON["title"].stringValue
                    abc.descriptionMy = subJSON["description"].stringValue
                    abc.publishedAt = subJSON["publishedAt"].stringValue
                    abc.url = subJSON["url"].stringValue
                    abc.urlToImage = subJSON["urlToImage"].stringValue
                    //self.newArt.authorList.append(subJSON["author"].stringValue)
                    //self.newArt.titleList.append(subJSON["title"].stringValue)
                    
                    self.myArray.append(abc)

                }
                
                print("МАССИВ ЗАПОЛНЕН \n***\(self.myArray)")
                
                try! myRealm.write {
                    myRealm.add(self.myArray, update: true)
                }
                
            case .failure(let error):
                print(error)
            
            }
        }
        
        print("*****************\n\("ПРОВЕРКА СВЯЗИ: в массиве \(self.myArray.count) объектов.")")

        return self.myArray
    }
    
    
    func loadArticlesFromDataBase() -> [MyNewRealm] {
   
    
        return self.myArray
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
        //let aaa = classCityList
        return myArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        
        //let aaa = classCityList
        cell.myTitle?.text = myArray[indexPath.row].title
        //cell.authorTitle? = aaa[indexPath.row]
        
        //print("Hello \(aaa)")
        
        try! self.realmMain.write {
            self.realmMain.deleteAll()
            print("empty")
        }
        
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
 
 } */


var load: AnyObject? {
    get {
        return UserDefaults.standard.object(forKey: "flag") as AnyObject?
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "flag")
        UserDefaults.standard.synchronize()
    }
}
