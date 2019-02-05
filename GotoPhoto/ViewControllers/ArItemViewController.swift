

import Foundation
import CoreLocation
import UIKit
import AVKit
import Kingfisher

protocol LocatableItem : class
{
  var geolocation : Geolocation? { get }
  var mapLabel: String? { get }
  var image: URL? { get }
  var id: Int { get }
}

class Geolocation
{
  var latitude : Double = 0.0
  var longitude: Double = 0.0
  
  init(latitude: Double, longitude: Double)
  {
    self.latitude = latitude
    self.longitude = longitude
  }
}

class LocatableItemARAnnotation: ARAnnotation
{
  var image: URL?
  
  init?(identifier: String?, title: String?, image: URL?, location: CLLocation)
  {
    self.image = image
    super.init(identifier: identifier, title: title, location: location)
  }
}

class ArItemViewController : ARViewController, ARDataSource, AVCapturePhotoCaptureDelegate
{
  let items: [LocatableItem]
  init(for items: [LocatableItem])
  {
    self.items = items
    
    super.init()
    
    self.dataSource = self
    self.presenter.maxVisibleAnnotations = 1
    //self.presenter.maxDistance = 1000000
    self.trackingManager.reloadDistanceFilter = 1
    self.trackingManager.userDistanceFilter = 1
    self.trackingManager.minimumHeadingAccuracy = 180
    //self.trackingManager.headingFilterFactor = 0.0
    self.trackingManager.reportPeriodSeconds = 2
    self.addCloseButton()
    addAlphaSlider()
    addSnapshotButton()
    
    var annotations: [LocatableItemARAnnotation] = []
    
    for item in items
    {
      if let geolocation = item.geolocation
      {
        let place = LocatableItemARAnnotation(identifier: item.mapLabel, title: item.mapLabel, image: item.image, location: CLLocation(latitude: geolocation.latitude, longitude: geolocation.longitude))!
        annotations.append(place)
      }
    }
    
    self.setAnnotations(annotations)
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  var alphaSlider: UISlider?
  
  func addAlphaSlider()
  {
    self.alphaSlider?.removeFromSuperview()
    
    // Alpha Slider
    let height = 30
    let width = Int(self.view.bounds.size.width) - 100
    let top : Int = Int(self.view.bounds.size.height) - 50
    let alphaSlider: UISlider = UISlider(frame: CGRect(x: 50, y: top,
                                                       width: width, height: height))
    alphaSlider.maximumValue = 1.0
    alphaSlider.minimumValue = 0.0
    alphaSlider.value = 0.7
    alphaSlider.addTarget(self, action: #selector(alphaSliderValueDidChange), for: UISlider.Event.valueChanged)
    self.view.addSubview(alphaSlider)
    self.alphaSlider = alphaSlider
  }
  
  var snapshotButton: UIButton?
  
  func addSnapshotButton()
  {
    self.snapshotButton?.removeFromSuperview()
    
    // Snapshot button
    let size = 60
    let top = (Int(self.view.bounds.size.height) - 70) - size
    let left = (Int(self.view.bounds.size.width) - size) / 2
    let snapshotButton: UIButton = UIButton(frame: CGRect(x: left, y: top, width: size, height: size))
    if let buttonImage = UIImage(named: "Snapshot")
    {
      snapshotButton.setImage(buttonImage, for: .normal)
      snapshotButton.addTarget(self, action: #selector(didTakeSnapshot), for: UIButton.Event.touchUpInside)
      self.view.addSubview(snapshotButton)
      self.snapshotButton = snapshotButton
    }
  }

  @objc func alphaSliderValueDidChange()
  {
    if let alpha = alphaSlider?.value
    {
      for annotation in self.getAnnotations()
      {
        if let item = annotation as? LocatableItemARAnnotation, let view = item.annotationView as? LocatableItemARAnnotationView
        {
          view.imageView?.alpha = CGFloat(alpha)
        }
      }
    }
  }
  

  @objc func didTakeSnapshot()
  {
    let photoSettings = AVCapturePhotoSettings()
    self.cameraView.capturePhotoOutput?.capturePhoto(with: photoSettings, delegate: self)
  }
  
  var photoOrientation: UIImage.Orientation
  {
    var currentDevice: UIDevice
    currentDevice = .current
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    var deviceOrientation: UIDeviceOrientation
    deviceOrientation = currentDevice.orientation
    
    var imageOrientation: UIImage.Orientation!
    
    if deviceOrientation == .portrait
    {
      imageOrientation = .right
      print("Device: Portrait")
    }
    else if (deviceOrientation == .landscapeLeft)
    {
      imageOrientation = .up
      print("Device: LandscapeLeft")
    }
    else if (deviceOrientation == .landscapeRight)
    {
      imageOrientation = .down
      //CustomCamera.cameraPreviewLayer?.connection?.videoOrientation = .landscapeRight
      print("Device LandscapeRight")
    }
    else if (deviceOrientation == .portraitUpsideDown)
    {
      imageOrientation = .left
      //print("Device PortraitUpsideDown")
    }
    else
    {
      imageOrientation = .up
    }
    return imageOrientation
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
  {
    if let cgcapture = photo.cgImageRepresentation()
    {
      let capture = UIImage(cgImage: cgcapture.takeUnretainedValue(), scale: 1.0, orientation: photoOrientation)
      
      if let url = saveImage(image: capture, name: UUID().uuidString)
      {
        PhotoDatabase.instance.addUserPhoto(userPhoto: UserPhoto(photoLocationId: items[0].id, fileUrl: url))
      }
    }
    //UIImageWriteToSavedPhotosAlbum(capture, nil, nil, nil)
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    
  }
  


  
  class LocatableItemARAnnotationView : ARAnnotationView
  {
    var titleLabel: UILabel?
    var imageView: UIImageView?
    
    override func didMoveToSuperview()
    {
      super.didMoveToSuperview()
      loadUI()
    }
    
    override open func initialize()
    {
      super.initialize()
      self.loadUI()
    }
    
    override  func bindUi()
    {
      if let annotation = annotation
      {
        var distanceString = "\(Int(annotation.distanceFromUser))m"
        if annotation.distanceFromUser > 2000
        {
          distanceString = "\(Int(annotation.distanceFromUser / 1000))km"
        }
        titleLabel?.text = "\(annotation.title!)\n\(distanceString) Bearing:\(Int(annotation.azimuth))º"
        titleLabel?.sizeToFit()
        titleLabel?.frame.size.width = self.frame.size.width
      }
      
    }
    
    func loadUI()
    {
      titleLabel?.removeFromSuperview()
      imageView?.removeFromSuperview()
      
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 20))
      label.font = UIFont(name: "ArticulateCFv2-Text", size: 20)
      label.numberOfLines = 0
      label.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
      label.textColor = UIColor.white
      label.textAlignment = .center
      self.addSubview(label)
      self.titleLabel = label
      
      if let image = (annotation as? LocatableItemARAnnotation)?.image
      {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width))
        iv.alpha = 0.5
        iv.contentMode = .scaleAspectFit
        self.addSubview(iv)
        self.imageView = iv
        iv.kf.setImage(with: image)
      }
      
      bindUi()
    }
    
    
    override func layoutSubviews()
    {
      super.layoutSubviews()
      
      //titleLabel?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 5, height: titleLabel!.frame.size.height)
      imageView?.frame = CGRect(x: 0, y: titleLabel?.frame.size.height ?? 0, width: self.frame.size.width, height: self.frame.size.width)
    }
    
  }
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView
  {
    let annotationView = LocatableItemARAnnotationView()
    //annotationView.frame = CGRect(x: 0, y: 0, width: 170, height: 50)
    annotationView.frame = CGRect(x: 0, y: 0, width: arViewController.view.frame.size.width, height: arViewController.view.frame.size.height)

    return annotationView
  }
  
  
  func ar(_ arViewController: ARViewController, shouldReloadWithLocation location: CLLocation) -> [ARAnnotation]
  {
    return arViewController.getAnnotations()
  }
  
}


func saveImage (image: UIImage, name: String ) -> URL?
{
  if let pngImageData = image.jpegData(compressionQuality: 0.5)
  {
    //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
    let fileManager = FileManager.default
    do
    {
      let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
      let fileURL = documentDirectory.appendingPathComponent(name)
      try pngImageData.write(to: fileURL)
      return fileURL
      
    }
    catch
    {
      print(error)
    }
  }
  return nil
}

func loadImage(withUrl url: URL) -> UIImage?
{
  do
  {
    let imageData = try Data(contentsOf: url)
    if let image = UIImage(data: imageData)
    {
      return image
    }
  }
  catch
  {
    print(error)
  }
  
  return nil
}

func image(with view: UIView) -> UIImage?
{
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
  defer { UIGraphicsEndImageContext() }
  if let context = UIGraphicsGetCurrentContext()
  {
    view.layer.render(in: context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image
  }
  return nil
}

