//
//  ShowNaviViewController.swift
//  SNApp
//
//  Created by apple on 08.08.17.
//  Copyright © 2017 Korona. All rights reserved.
//

import UIKit

class ShowNaviViewController: UIViewController {

    @IBOutlet weak var loadingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showNaviController()
        perform(#selector(ShowNaviViewController.showNaviController), with: nil, afterDelay: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNaviController() {
        performSegue(withIdentifier: "showNaviController", sender: self)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
