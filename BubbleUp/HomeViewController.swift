//HomeViewController is connected to the home screen (second screen in Main.storyboard)

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate {
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

//            annotationView.image = UIImage(named: "BubbleUp_bubble1")
//            annotationView.canShowCallout = true
//
//            return annotationView
        if let originalImage = UIImage(named: "BubbleUp_bubble1") {
        
            let regionSpan = mapView.region.span
            let zoomLevel = log2(360.0 / Double(regionSpan.longitudeDelta)) + 1.0
            let scaleFactor = pow(2, zoomLevel) / 900.0  // Adjust this factor as needed
            let aspectRatio = originalImage.size.width / originalImage.size.height
            let targetHeight = scaleFactor / aspectRatio
            
            let size = CGSize(width: scaleFactor, height: targetHeight)

//                let size = CGSize(width: 2, height: 2)
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
                        let aspectRatio = originalImage.size.width / originalImage.size.height
                        let targetHeight = scaleFactor / aspectRatio
                        
                        let size = CGSize(width: scaleFactor, height: targetHeight)

                        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                        originalImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
                        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()

                        annotationView.image = resizedImage
                    }
                }
            }
        }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotationTitle = view.annotation?.title {
                print("Clicked on annotation: \(annotationTitle!)")
                let alertController = UIAlertController(title: "Annotation Menu", message: "Do you want to perform an action?", preferredStyle: .actionSheet)

                // Add an action to the menu
                let action = UIAlertAction(title: "View Attendees", style: .default) { (action) in
                    print("Clicked on annotation:")
                    // Instantiate the view controller you want to navigate to
//                    let attendeesViewController = EventViewController()
//
//                    // Push the new view controller onto the navigation stack
//                    self.navigationController?.pushViewController(attendeesViewController, animated: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil);
                   let vc = storyboard.instantiateViewController(withIdentifier: "AttendeesViewController")
                    self.present(vc, animated: true, completion: nil);
                }
                alertController.addAction(action)

                // Add a cancel action to dismiss the menu
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)

                // Present the menu
                present(alertController, animated: true, completion: nil)
            }
        }
    func displayLocation(){
        
        let locations = [["title":"Cabtree Hall", "latitude":42.39417125812856, "longitude": -72.5251287131496],["title":"Gunnness", "latitude":42.39407617603182, "longitude": -72.52949534922335],["title":"Library", "latitude":42.3897022438628, "longitude": -72.52839027916046],["title":"Library", "latitude":16.3, "longitude": 71.5]]
        
        
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

