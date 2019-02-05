//
//  ChooseLocationTableViewCell.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 3/1/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import UIKit

class ChooseLocationTableViewCell: UITableViewCell
{
  @IBOutlet weak var locationTitleLabel: UILabel!
  @IBOutlet weak var locationDetailLabel: UILabel!
  
  var location: Location!
  {
    didSet
    {
      locationTitleLabel.text = location.location
      locationDetailLabel.text = "No detail available"
    }
  }
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool)
  {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
