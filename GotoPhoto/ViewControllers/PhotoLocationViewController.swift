//
//  ViewController.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 21/12/18.
//  Copyright © 2018 Chris Shaw. All rights reserved.
//

import UIKit

class PhotoLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  @IBOutlet weak var imagePreview: UIImageView!
  @IBOutlet weak var arButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  var photo: PhotoLocation!
  
  var userPhotos: [UserPhoto] = []
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    tableView.dataSource = self
    tableView.delegate = self
    
    imagePreview.kf.setImage(with: photo.image)
  }
  
  override func viewDidAppear(_ animated: Bool)
  {
    super.viewDidAppear(animated)
    userPhotos = PhotoDatabase.instance.userPhotos.filter({$0.photoLocationId == photo.id})
    tableView.reloadData()
  }
  
  
  @IBAction func onArButton(_ sender: Any)
  {
    let arvc = ArItemViewController(for: [photo])
    self.present(arvc, animated: true, completion: nil)
  }

  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return userPhotos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserPhotoCell") as! UserPhotoTableViewCell
    
    cell.userPhoto = userPhotos[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    if let imageUrl = userPhotos[indexPath.row].fileUrl
    {
      let keyWindow = UIApplication.shared.keyWindow!
      let newImageView = UIImageView(frame: keyWindow.bounds)
      // Set frame and content mode BEFORE the image
      // Setting image first stopped the scaling from working
      newImageView.contentMode = .scaleAspectFit
      newImageView.image = loadImage(withUrl: imageUrl)
      newImageView.backgroundColor = .black
      newImageView.isUserInteractionEnabled = true
      let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
      newImageView.addGestureRecognizer(tap)
      keyWindow.addSubview(newImageView)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
  {
    let delete = UITableViewRowAction(style: .destructive, title: "Delete")
    { (action, indexPath) in
      // delete item at indexPath
      let item = self.userPhotos[indexPath.row]
      PhotoDatabase.instance.removeUserPhoto(withId: item.id)
      self.userPhotos.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    /*
    let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
      // share item at indexPath
      print("I want to share: \(self.tableArray[indexPath.row])")
    }
     share.backgroundColor = UIColor.lightGray
    */
    

    return [delete]
    
  }
  
  @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer)
  {
    sender.view?.removeFromSuperview()
  }
  
}

