//
//  ImageViewController.swift
//  BubbleUp
//
//  Created by Vi Doan on 12/11/2023.
//

import UIKit
import MapKit

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubtite:String, location:CLLocationCoordinate2D){
        self.title = pinTitle
        self.subtitle = pinSubtite
        self.coordinate = location
    }
}


class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the initial region
        let initialLocation = CLLocationCoordinate2D(latitude: 42.39345021529907, longitude: -72.52553640890095)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let initialRegion = MKCoordinateRegion(center: initialLocation, span: span)

        mapView.setRegion(initialRegion, animated: true)
        
        
        displayLocation()
        self.mapView.delegate = self
        fetchLocations()

    }

    
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation{
                return nil
            }
            var annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            if let originalImage = UIImage(named: "BubbleUp_bubble1") {
            
                let targetWidth: CGFloat = 2 // or any other desired width
                let aspectRatio = originalImage.size.width / originalImage.size.height
                let targetHeight = targetWidth / aspectRatio

                let size = CGSize(width: targetWidth, height: targetHeight)

                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                originalImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                annotationView.image = resizedImage
                annotationView.canShowCallout = true

                return annotationView
            }

            return nil
        }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            updateAnnotationImages(for: mapView)
        }

        func updateAnnotationImages(for mapView: MKMapView) {
            for annotation in mapView.annotations {
                if let annotationView = mapView.view(for: annotation) as? MKAnnotationView {
                    if let originalImage = UIImage(named: "BubbleUp_bubble1") {
                        let regionSpan = mapView.region.span
                        let zoomLevel = log2(360.0 / Double(regionSpan.longitudeDelta)) + 1.0
                        let scaleFactor = pow(2, zoomLevel) / 900.0  // Adjust this factor as needed
                        let size = CGSize(width: scaleFactor, height: scaleFactor)

                        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                        originalImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()

                        annotationView.image = resizedImage
                    }
                }
            }
        }
    

    func displayLocation(){
        
        let locations = [["title":"Mumbai", "latitude":42.39417125812856, "longitude": -72.5251287131496],["title":"Mumbai2", "latitude":42.39407617603182, "longitude": -72.52949534922335],["title":"Mumbai3", "latitude":42.3897022438628, "longitude": -72.52839027916046],["title":"Mumbai4", "latitude":16.3, "longitude": 71.5]]
        
        
        for location in locations{
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            let loc = CLLocationCoordinate2D(latitude: location["latitude"] as! Double, longitude: location["longitude"] as! Double)
            
            annotation.coordinate = loc
            mapView.addAnnotation(annotation)
        }
        
    }
    
    
    
    func fetchLocations(){
        guard let url = URL(string: "http://localhost:3000/api/posts") else{
            return
        }


        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let data = data, let string = String(data: data, encoding: .utf8){
                print(string)
            }
        }

        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
