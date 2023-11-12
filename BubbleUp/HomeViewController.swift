//HomeViewController is connected to the home screen (second screen in Main.storyboard)

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    let baseCoordinate = CLLocationCoordinate2DMake(44.1487225,-87.5684114)
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended{
            let locationInView = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView , toCoordinateFrom: mapView)
            addAnnotation(coordinate: tappedCoordinate)
        }
    }
    
    @IBAction func clearAnnotations(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func addAnnotation(coordinate:CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
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
