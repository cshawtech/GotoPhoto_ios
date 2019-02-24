//
//  HomePageViewController.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 6/2/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  @IBAction func onSynchronisePressed(_ sender: Any)
  {
    PortalReader.instance.synchronise()
  }
  
  
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
