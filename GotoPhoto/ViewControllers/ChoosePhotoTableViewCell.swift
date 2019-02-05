//
//  ChoosePhotoTableViewCell.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 3/1/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import UIKit

class ChoosePhotoTableViewCell: UITableViewCell
{
  @IBOutlet weak var photoTitleLabel: UILabel!
  @IBOutlet weak var photoDetailLabel: UILabel!
  @IBOutlet weak var imagePreview: UIImageView!
  
  var photo: PhotoLocation!
  {
    didSet
    {
      photoTitleLabel.text = photo.title
      photoDetailLabel.text = photo.photo_description
      imagePreview.kf.setImage(with: photo.image)
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
