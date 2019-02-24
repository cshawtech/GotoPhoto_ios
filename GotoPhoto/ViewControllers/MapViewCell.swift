//
//  MapViewCell.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 22/2/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import UIKit
import ArcGIS

class MapViewCell: UITableViewCell
{
  
  @IBOutlet weak var mapView: AGSMapView!
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    // Initialization code
    mapView.map = AGSMap(basemapType: .openStreetMap, latitude: -35.0, longitude: 145.0, levelOfDetail: 12)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
