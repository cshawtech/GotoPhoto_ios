//
//  ViewController.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 21/12/18.
//  Copyright © 2018 Chris Shaw. All rights reserved.
//

import UIKit

class PhotoLocationViewController: UIViewController
{
  @IBOutlet weak var arButton: UIButton!
  var photo: PhotoLocation!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
  @IBAction func onArButton(_ sender: Any)
  {
    let arvc = ArItemViewController(for: [photo])
    self.present(arvc, animated: true, completion: nil)
  }
}

