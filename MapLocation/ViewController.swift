//
//  ViewController.swift
//  MapLocation
//
//  Created by RaviSingh on 25/01/21.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class ViewController: UIViewController, searchViewControllerDelegate {
   
    
    
    let mapView = MKMapView()
    let panel = FloatingPanelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        let searchVC = SearchViewController()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
        title = "Map"
    }

    func searchViewController(_vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        
        guard let coordinates = coordinates else {return}
        panel.move(to: .tip, animated: true, completion: nil)
        mapView.removeAnnotations(mapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
    }
   
}

