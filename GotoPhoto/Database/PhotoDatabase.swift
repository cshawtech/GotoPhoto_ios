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
    //realm.deleteSafe(realm.objects(UserPhoto.self).toArray())
    if realm.objects(PhotoLocation.self).count == 0
    {
      let photo1 = PhotoLocation(id: 1,
                                 location: 1,
                                 title: "Test Photo",
                                 latitude: -38.296738, longitude: 145.002563,
                                 photo_description: "Three boulders in Mt Martha Park, Victoria",
                                 url: "https://storage.googleapis.com/gotophoto.appspot.com/boulders.jpg")
      realm.addSafe(photo1)
      let location1 = Location(id: 1, location: "Mt Martha Park, Victoria")
      realm.addSafe(location1)
      let location2 = Location(id: 2, location: "At Home")
      realm.addSafe(location2)
      let photo3 = PhotoLocation(id: 2, location: 2, title: "Sunflower", latitude: -38.295429, longitude: 144.992635, photo_description: "Our beautiful sunflower", url: "https://storage.googleapis.com/gotophoto.appspot.com/IMG_0024_small.jpeg")
      let photo4 = PhotoLocation(id: 3, location: 2, title: "Lotus", latitude: -38.295467, longitude: 144.992783, photo_description: "The Lotus kinetic sculpture", url: "https://storage.googleapis.com/gotophoto.appspot.com/IMG_0025_small.jpeg")
      realm.addSafe([photo3, photo4])
      
    }
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
