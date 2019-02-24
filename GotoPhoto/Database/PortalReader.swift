//
//  PortalReader.swift
//
//  Created by Chris Shaw.
//

import Foundation

protocol PortalReaderDelegate: class
{
  func portalReader(didReadLocations locations : [Location])
  func portalReader(didReadPhotos photos : [PhotoLocation])
  
  func portalReaderDownloadFailed()
}

class PortalReader: NSObject, URLSessionDataDelegate
{
  static let instance = PortalReader()

  let portalBaseAddress = "https://gotophoto.appspot.com/v1"
  let locationsApi = "locations"
  let photolocationsApi = "locationphotos"
  var isSynchronising = false
  var synchroStep = 0
  
  //properties
  weak var delegate: PortalReaderDelegate? = nil
  
  func synchronise()
  {
    if !isSynchronising
    {
      synchroStep = 0
      nextSynchroniseStep()
    }
  }
  
  func nextSynchroniseStep()
  {
    synchroStep += 1
    if synchroStep == 1
    {
      readLocations()
    }
    else if synchroStep == 2
    {
      readPhotolocations()
    }
    else
    {
      synchroStep = 0
      isSynchronising = false
      notifyViewer()
    }
  }
  
  func notifyViewer()
  {

  }
  
  func endpointFor(api: String) -> String
  {
    return portalBaseAddress + "/" + api
  }
  
  func createRequest(apiEndpoint: String) -> URLRequest
  {
    let url = URL(string: apiEndpoint)!
    let request = URLRequest(url: url)
    
    return request
  }
  
  func portalSession(request: URLRequest?, successHandler: @escaping (Data) -> Void)
  {
    if let request = request
    {
      let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
      
      let task = defaultSession.dataTask(with: request)
      { (data, response, error) in
        if error != nil
        {
          DispatchQueue.main.async(execute:
            { () -> Void in
              self.delegate?.portalReaderDownloadFailed()
          })
        }
        else
        {
          if let r = response as? HTTPURLResponse
          {
            NSLog("Response: \(r.statusCode)")
            
            if let data = data
            {
              NSLog("Data Response: \(String.init(data: data, encoding: .utf8) ?? "")")
              DispatchQueue.main.async {
                successHandler(data)
                self.nextSynchroniseStep()
              }
            }
            else
            {
              self.delegate?.portalReaderDownloadFailed()
              self.isSynchronising = false
            }
          }
          else
          {
            self.delegate?.portalReaderDownloadFailed()
            self.isSynchronising = false
          }
        }
      }
      
      task.resume()
    }
    else
    {
      self.delegate?.portalReaderDownloadFailed()
    }
  }
  
}

extension PortalReader
{
  func readLocations()
  {
    portalSession(request: createRequest(apiEndpoint: endpointFor(api: locationsApi)), successHandler:
      { (data: Data) -> Void in
        let decoder = JSONDecoder()
        do
        {
          let locations = try decoder.decode([Location].self, from: data)
          PhotoDatabase.instance.updateLocations(locations: locations)
        }
        catch
        {
          
        }
      }
    )
  }
  func readPhotolocations()
  {
    portalSession(request: createRequest(apiEndpoint: endpointFor(api: photolocationsApi)), successHandler:
      { (data: Data) -> Void in
        let decoder = JSONDecoder()
        do
        {
          let photolocations = try decoder.decode([PhotoLocation].self, from: data)
          PhotoDatabase.instance.updatePhotoLocations(photolocations: photolocations)
        }
        catch
        {
          
        }
      }
    )
  }
}
