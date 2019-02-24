//
//  ChoosePhotoTableViewController.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 3/1/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import UIKit

class ChoosePhotoTableViewController: UITableViewController
{
  var location: Location!
  var photos: [PhotoLocation]!
  var selectedPhoto: PhotoLocation!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    photos = PhotoDatabase.instance.photosAtLocation(locationId: location.id)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return photos.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! ChoosePhotoTableViewCell
    
    // Configure the cell...
    cell.photo = photos[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    selectedPhoto = photos[indexPath.row]
    performSegue(withIdentifier: "ChoosePhoto", sender: nil)
  }
    
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    let destination = segue.destination as! PhotoLocationViewController
    destination.photo = selectedPhoto
  }
  
  
}
