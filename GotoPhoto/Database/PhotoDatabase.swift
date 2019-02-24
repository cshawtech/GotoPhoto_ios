//
//  PhotoDatabase.swift
//  GotoPhoto
//
//  Created by Chris Shaw on 1/1/19.
//  Copyright © 2019 Chris Shaw. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoDatabase
{
  static let instance = PhotoDatabase()
  let realm: Realm
  
  init()
  {
    var config = Realm.Configuration()
    config.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration = config
    self.realm = try! Realm()
  }

  
  var allPhotos: [PhotoLocation]
  {
    return realm.objects(PhotoLocation.self).toArray()
  }
  
  func locationOfPhoto(photo: PhotoLocation) -> Location?
  {
    return allLocations.first(where: {$0.id == photo.location})
  }
  
  var allLocations: [Location]
  {
    return realm.objects(Location.self).toArray()
  }
  
  func photosAtLocation(locationId: Int) -> [PhotoLocation]
  {
    return allPhotos.filter {$0.location == locationId} 
  }
  
  var userPhotos: [UserPhoto]
  {
    return realm.objects(UserPhoto.self).toArray()
  }
  func addUserPhoto(userPhoto: UserPhoto)
  {
    realm.addSafe(userPhoto)
  }
  func removeUserPhoto(withId id: Int)
  {
    if let photo = realm.object(ofType: UserPhoto.self, forPrimaryKey: id)
    {
      realm.deleteSafe(photo)
    }
  }
  
  func updateLocations(locations: [Location])
  {
    realm.update
    {
      realm.add(locations, update: true)
    }
  }
  func updatePhotoLocations(photolocations: [PhotoLocation])
  {
    realm.update
    {
      realm.add(photolocations, update: true)
    }
  }
}


extension RealmCollection
{
  func toArray<T>() ->[T]
  {
    return self.compactMap{$0 as? T}
  }
}

extension Object
{
  func save()
  {
    realm?.update(self)
  }
}

extension Realm
{
  func update<T : Object>(_ object: T)
  {
    if isInWriteTransaction
    {
      add(object)
    }
    else
    {
      try! write
      {
        add(object, update: true)
      }
    }
  }
  
  func update(_ actions: () -> Void)
  {
    let wasWriting = isInWriteTransaction
    
    if !wasWriting
    {
      beginWrite()
    }
    
    actions()
    
    if !wasWriting
    {
      try! commitWrite()
    }
  }
  
  func addSafe<T : Object>(_ object: T)
  {
    if isInWriteTransaction
    {
      add(object)
    }
    else
    {
      try! write
      {
        add(object)
      }
    }
  }
  func addSafe<T : Object>(_ objects: [T])
  {
    if isInWriteTransaction
    {
      add(objects)
    }
    else
    {
      try! write
      {
        add(objects)
      }
    }
  }
  
  func deleteSafe<T : Object>(_ object: T)
  {
    if isInWriteTransaction
    {
      delete(object)
    }
    else
    {
      try! write
      {
        delete(object)
      }
    }
  }
  func deleteSafe<T : Object>(_ objects: [T])
  {
    if isInWriteTransaction
    {
      delete(objects)
    }
    else
    {
      try! write
      {
        delete(objects)
      }
    }
  }
}
