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
  //properties
  weak var delegate: PortalReaderDelegate? = nil
  
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
              successHandler(data)
            }
            else
            {
              self.delegate?.portalReaderDownloadFailed()
            }
          }
          else
          {
            self.delegate?.portalReaderDownloadFailed()
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

