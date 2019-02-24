//
//  ChooseLocationTableViewController.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 3/1/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import UIKit
import ArcGIS

class ChooseLocationTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  let database = PhotoDatabase()
  var allLocations: [Location]!
  var selectedLocation: Location!
  @IBOutlet weak var mapView: AGSMapView!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    allLocations = database.allLocations
    tableView.refreshControl?.addTarget(self,
                                        action: #selector(ChooseLocationTableViewController.handleRefresh(_:)),
                                        for: UIControl.Event.valueChanged)
    mapView.map = AGSMap(basemapType: .openStreetMap, latitude: -33.0, longitude: 145.0, levelOfDetail: 6)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl)
  {
    refreshControl.endRefreshing()
  }

  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return allLocations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! ChooseLocationTableViewCell
    
    // Configure the cell...
    cell.location = allLocations[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    selectedLocation = allLocations[indexPath.row]
    tableView.deselectRow(at: indexPath, animated: true)
    //performSegue(withIdentifier: "ChooseLocation", sender: nil)
    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChoosePhotoTableViewController") as! ChoosePhotoTableViewController
    vc.location = selectedLocation
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
     let destination = segue.destination as! ChoosePhotoTableViewController
     destination.location = selectedLocation
   }
  
  
}
