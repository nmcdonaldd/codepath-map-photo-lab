//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController {

    @IBOutlet weak var cameraButtonView: CameraButtonView!
    @IBOutlet weak var mapView: MKMapView!
    fileprivate var pickedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Map"
        self.mapView.delegate = self
        let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        // Set animated property to true to animate the transition to the region
        self.cameraButtonView.isUserInteractionEnabled = true
        self.cameraButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraViewTapped)))
        self.mapView.setRegion(region, animated: false)
    }

    func cameraViewTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController(title: "Pick an image source", message: nil, preferredStyle: .actionSheet)
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action: UIAlertAction) in
                self.presentPhotoLibrary()
            }
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                self.presentCamera()
            })
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibraryAction)
        } else {
            self.presentPhotoLibrary()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func presentCamera() {
        let imagePickerController = self.grabImagePickerController()
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func presentPhotoLibrary() {
        let imagePickerController = self.grabImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? LocationsViewController else {
            return
        }
        destination.delegate = self
    }
    
    private func grabImagePickerController() -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
}

extension PhotoMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.pickedImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        self.dismiss(animated: true) { 
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
}

extension PhotoMapViewController: LocationsViewControllerDelegate {
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude as! Double , longitude: longitude as! Double)
        annotation.coordinate = locationCoordinate
        annotation.title = String(describing: latitude)
        self.mapView.addAnnotation(annotation)
    }
}

extension PhotoMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("Hello!")
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            print("Annotation view was nil, instantiating!")
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        // Add the image you stored from the image picker
        imageView.image = self.pickedImage
        imageView.contentMode = .scaleAspectFill
        
        return annotationView
    }
}
