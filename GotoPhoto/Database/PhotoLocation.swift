//
//  PhotoDatabase.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 1/1/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import Foundation
import RealmSwift

class Location : Object, Codable
{
  @objc dynamic var id: Int = 0
  @objc dynamic var location: String = ""
  
  override static func primaryKey() -> String?
  {
    return "id"
  }

  convenience init(id: Int, location: String)
  {
    self.init()
    
    self.id = id
    self.location = location
  }
}

class PhotoLocation : Object, LocatableItem, Codable
{
  @objc dynamic var id: Int = 0
  @objc dynamic var location: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var latitude: Double = 0.0
  @objc dynamic var longitude: Double = 0.0
  @objc dynamic var photo_description: String = ""
  @objc dynamic var url: String = ""
  
  override static func primaryKey() -> String?
  {
    return "id"
  }

  convenience init(id: Int, location: Int, title: String, latitude: Double, longitude: Double, photo_description: String, url: String)
  {
    self.init()
    
    self.id = id
    self.location = location
    self.title = title
    self.latitude = latitude
    self.longitude = longitude
    self.photo_description = photo_description
    self.url = url
  }
  
  var geolocation: Geolocation?
  {
    return Geolocation(latitude: latitude, longitude: longitude)
  }
  
  var mapLabel: String?
  {
    return title
  }
  
  var image: URL?
  {
    return URL(string: url)
  }
  
  var locationRecord: Location?
  {
    return self.realm?.objects(Location.self).filter("id = %@", self.location).first
  }
}

class UserPhoto: Object
{
  static var newId: Int = 0
  @objc dynamic var id: Int = 0
  @objc dynamic var photoLocationId: Int = 0
  @objc dynamic var timestamp: Date? = nil
  @objc dynamic var _fileUrl: String = ""
  
  override static func primaryKey() -> String?
  {
    return "id"
  }

  convenience init(photoLocationId: Int, fileUrl: URL)
  {
    self.init()
    
    self.id = UserPhoto.newId
    UserPhoto.newId += 1
    self.photoLocationId = photoLocationId
    self._fileUrl = fileUrl.lastPathComponent
    self.timestamp = Date()
  }
  
  var fileUrl: URL?
  {
    let fileManager = FileManager.default
    do
    {
      let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
      let fileURL = documentDirectory.appendingPathComponent(_fileUrl)
      
      return fileURL
    }
    catch
    {
      
    }
    return nil
  }
}
