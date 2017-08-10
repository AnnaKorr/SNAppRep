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

class NewsListViewController: UITableViewController {
    @IBOutlet weak var tblView: UITableView!

    let realmMain = try! Realm()
    var newNewsArray = [NewsRealm]()

    let managerDataLoader: ManagerData = ManagerData()
    
    var titlesArray: [String] = []
    var authorsArray: [String] = []
    var descriptionArray: [String] = []
    var imagesLinksArray: [String] = []
    var hyperLinksArray: [String] = []
    
    let queGoupp = DispatchGroup()
    let concurQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? Any.self)
        let letsTest = managerDataLoader.loadArticlesFromDataBase()
        
        managerDataLoader.loadData(data: newNewsArray)
        
        titlesArray = letsTest.0
        authorsArray = letsTest.1
        descriptionArray = letsTest.2
        imagesLinksArray = letsTest.3
        hyperLinksArray = letsTest.4
        
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 104.0
        
        print("\n ************* ПРОВЕРКА: в массиве \(letsTest.0.count) заголовков, \(letsTest.1.count) авторов статей, \(letsTest.2.count) подробных описаний, \(letsTest.3.count) ссылок на изображения, \(letsTest.4.count) уникальных ссылок на статьи.")
        print("\n ************* СОДЕРЖАНИЕ ЯЧЕЕК: \(letsTest.0)\n \(letsTest.1)\n \(letsTest.2)\n \(letsTest.3)\n \(letsTest.4)")
        
        self.tblView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return titlesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell",
                                                 for: indexPath) as! MyTableViewCell
        
        cell.myTitle?.text = self.titlesArray[indexPath.row]
        cell.authorTitle?.text = self.authorsArray[indexPath.row]
        
        try! self.realmMain.write {
            self.realmMain.deleteAll()
            print("empty")
        }
        
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        
        if segue.identifier == "detailsSegue" {
            
            if let myIndexPath = tblView.indexPathForSelectedRow {
                
                let destination2DetailsController = segue.destination as! MyDetailViewController
                
                destination2DetailsController.titleInDetailsArray = [self.titlesArray[myIndexPath.row]]
                destination2DetailsController.authorsInDetailsArray = [self.authorsArray[myIndexPath.row]]
                destination2DetailsController.descriptionsIndetailsArray = [self.descriptionArray[myIndexPath.row]]
                destination2DetailsController.imagesInDetailsArray = [self.imagesLinksArray[myIndexPath.row]]
                destination2DetailsController.urlsInDetailsArray = [self.hyperLinksArray[myIndexPath.row]]
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
