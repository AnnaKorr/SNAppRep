//
//  MyDetailTableViewController.swift
//  SNApp
//
//  Created by apple on 25.07.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MyDetailViewController: UICollectionViewController {
   
    @IBAction func openBrowser(_ sender: UIButton) {
      NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "openSafari"), object: nil)
    }
    
    var titleInDetailsArray = NewsListViewController().titlesArray
    var authorsInDetailsArray = NewsListViewController().authorsArray
    var descriptionsIndetailsArray = NewsListViewController().descriptionArray
    var imagesInDetailsArray = NewsListViewController().imagesLinksArray
    var urlsInDetailsArray = NewsListViewController().hyperLinksArray
    let imgURLNew = NSURL(string: "https://techcrunch.com/")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        naviEdit()
     
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCollCell",
                                                      for: indexPath) as! MyCollectionViewCell
        
        cell.detTitLabel?.text = titleInDetailsArray[indexPath.row]
        cell.detAuthLabel?.text = authorsInDetailsArray[indexPath.row]
        cell.detDescrLabel?.text = descriptionsIndetailsArray[indexPath.row]
        
        let imgURL = NSURL(string: imagesInDetailsArray[indexPath.row])
        print("ССЫЛКA НА ИЗОБРАЖЕНИЕ: \n \(String(describing: imgURL))")
        
        cell.detImgLabel?.af_setImage(withURL: imgURL! as URL,
                                      placeholderImage:UIImage(named: "SNApp_placeholder"),
                                      filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: 375.0, height:190.0), radius: CGFloat(20.0)) as ImageFilter,
                                     imageTransition: .crossDissolve(0.5),
                                     runImageTransitionIfCached: true,
                                     completion:nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(opensSafari), name: NSNotification.Name.init(rawValue: "openSafari"), object: nil)
        
        return cell
    }
    
    
    func opensSafari() {
        UIApplication.shared.open(imgURLNew! as URL, options: [:], completionHandler: nil)
        print("Hello\n I'm a NotifCentre")
    }
    
    
    func naviEdit() {
        self.navigationController?.view.tintColor = UIColor.darkGray
        self.navigationController?.title = "Latest News"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
