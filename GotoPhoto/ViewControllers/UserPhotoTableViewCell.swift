//
//  UserPhotoTableViewCell.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 12/1/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import UIKit

class UserPhotoTableViewCell: UITableViewCell
{
  @IBOutlet weak var photoLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  
  var userPhoto: UserPhoto?
  {
    didSet
    {
      if let timestamp = userPhoto?.timestamp
      {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        photoLabel.text = formatter.string(from: timestamp)
      }
      else
      {
        photoLabel.text = ""
      }
      if let url = userPhoto?.fileUrl, let image = loadImage(withUrl: url)
      {
        userImage.image = image
      }
      else
      {
        userImage.image = nil
      }
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
