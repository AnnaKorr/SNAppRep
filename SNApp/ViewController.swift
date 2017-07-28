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
    var myArray = [MyNewRealm]()
    var toPrintArray: [String] = []
    var toPrintArray2: [String] = []
    
    
    //работа с очередями:
    let queGoupp = DispatchGroup()
    let concurQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? AnyObject.self)
        
        loadData(data: myArray)
        print("\n !!!!!!!!!!! ПРОВЕРКА: в массиве \(self.myArray.count) ОБЪЕКТОВ.")
        
        toPrintArray = loadArticlesFromDataBase().0
        toPrintArray2 = loadArticlesFromDataBase().1
       
        print("\n ************* ПРОВЕРКА: в массиве \(self.toPrintArray.count) названий, \(self.toPrintArray2.count) авторов.")
        

        print(toPrintArray)

        
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 200.0
        
        self.tblView.reloadData()
    }
    
    
    func loadData(data: Array<MyNewRealm>) {

        let myURl = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=8e1c098712084f1daae3de518d75e839"

        Alamofire.request(myURl, method: .get).validate().responseJSON(queue: concurQueue) {
            (myResp) in
            print("\n 1. start \(Thread.current)")
            
            let realm = try! Realm()
            switch myResp.result {
            case .success(let myValue):

                let myJSON = JSON(myValue)

                for (_, subJSON) in myJSON["articles"] {
                let infoo = MyNewRealm()
                    infoo.author = subJSON["author"].stringValue
                    infoo.title = subJSON["title"].stringValue
                    infoo.descriptionMy = subJSON["description"].stringValue
                    infoo.publishedAt = subJSON["publishedAt"].stringValue
                    infoo.url = subJSON["url"].stringValue
                    infoo.urlToImage = subJSON["urlToImage"].stringValue
                    self.myArray.append(infoo)
                }
                
                try! realm.write {
                    realm.add(self.myArray, update: true)
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
    
    func loadArticlesFromDataBase() -> ([String],[String]) {
        let realm = try! Realm()
        var artclsArray: [String] = []
        var authorsArray: [String] = []
        var resultCortege: ([String], [String])
        
        let data = realm.objects(MyNewRealm.self)
        
        for value in data {
            artclsArray.append(value.title)
            authorsArray.append(value.author)
        }
        
        resultCortege.0 = artclsArray
        resultCortege.1 = authorsArray
        
        try! realm.write {
            realm.add(data, update: true)
        }
        
        print("\n test \(artclsArray)\n \(authorsArray)")
        
        return resultCortege
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\n oops \(toPrintArray.count)")
        return toPrintArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.myTitle?.text = self.toPrintArray[indexPath.row]
        cell.authorTitle?.text = self.toPrintArray2[indexPath.row]
        
        try! self.realmMain.write {
            self.realmMain.deleteAll()
            print("empty")
        }
        
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let myIndexPath = tblView.indexPathForSelectedRow {
                let destination2DetailsController = segue.destination as! MyDetailViewController
                destination2DetailsController.titleInDetailsArray = [self.toPrintArray[myIndexPath.row]]
            }
        }
    }

/* 
 // если раскомментировать код, пройдем полный цикл создания и записи файла в локальную БД
 func loadFile() {
 let listNews = "https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=8e1c098712084f1daae3de518d75e839"
 
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


}
