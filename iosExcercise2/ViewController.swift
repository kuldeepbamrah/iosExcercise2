//
//  ViewController.swift
//  iosExcercise2
//
//  Created by MacStudent on 2020-01-13.
//  Copyright © 2020 Kuldeep Singh. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    var location2d : [CLLocationCoordinate2D] = []
    var locationArray : [CLLocation] = []
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // define lat and long
                
                let latitude: CLLocationDegrees = 43.64
                let longitude: CLLocationDegrees = -79.38
                
                // define delta lat and long
                
                let latDelta : CLLocationDegrees = 0.05
                let longDelta : CLLocationDegrees = 0.05
                
                //defione span
                let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
                
                // define location
                
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                // define the region
                
                let region = MKCoordinateRegion(center: location, span: span)
                
                // set the region on the map
                mapView.setRegion(region, animated: true)
                
                let uiLogr = UITapGestureRecognizer(target: self, action: #selector(longPress))
                
                mapView.addGestureRecognizer(uiLogr)

                
                
            }
            
           
            
            @objc func longPress(gestureRecogniser: UIGestureRecognizer)
            {
                 var address = ""
                let touchPoint = gestureRecogniser.location(in: mapView)
                          let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                          
                          let annotation = MKPointAnnotation()
                          annotation.coordinate = coordinate
                mapView.removeAnnotation(annotation)

                if mapView.annotations.count < 3
                {
                let touchPoint = gestureRecogniser.location(in: mapView)
                    let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    
                    
                    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    locationArray.append(location)
                let location2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                location2d.append(location2D)
                    for i in location2d
                    {
                        print(String(i.latitude) + "\n" + String(i.longitude))
                    }
                    
                    CLGeocoder().reverseGeocodeLocation(location){(placemarks, error) in
                    if let error = error
                    {
                        print(error)
                    }
                    else
                    {
                        if let placemark = placemarks?[0]{
                            //var address = ""
                            if placemark.subThoroughfare != nil{
                                address = address + placemark.subThoroughfare! + "\n"
                            }
                            
                            if placemark.thoroughfare != nil{
                                address = address + placemark.thoroughfare! + "\n"
                            }
                            
                            if placemark.subLocality != nil{
                                address = address + placemark.subLocality!  + "\n"
                            }
                            
                            if placemark.subAdministrativeArea != nil{
                                annotation.title = placemark.subAdministrativeArea

                                address = address + placemark.subAdministrativeArea! + "\n"
                            }
                            
                            if placemark.postalCode != nil{
                                address = address + placemark.postalCode! + "\n"
                            }
                            
                            if placemark.country != nil{
                                address = address + placemark.country! + "\n"
                            }
                          
                          print(address)
                      }
                    }
                    }
                annotation.title = address
                mapView.addAnnotation(annotation)

                }
                if mapView.annotations.count == 3
                {
                    addPolygon()

                }

        }
            
            
            public func addPolygon()
               {
                mapView.delegate=self
                    let polygon = MKPolygon(coordinates: &location2d, count: location2d.count)
                    mapView.addOverlay(polygon)
                }

        }

        extension ViewController: MKMapViewDelegate
        {

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
            else if overlay is MKPolyline{
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.green
                renderer.lineWidth = 3
                return renderer
            }
            else if overlay is MKPolygon{
                let renderer = MKPolygonRenderer(overlay: overlay)
                renderer.fillColor = UIColor.orange.withAlphaComponent(0.4)
                renderer.strokeColor = UIColor.green
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer()
        }
            
            func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                
                mapView.removeAnnotation(view.annotation!)
            }
            
            
            
            
            func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                
                let overlays = mapView.overlays
                mapView.removeOverlays(overlays)
                //let temp = view.annotation?.coordinate
                //let location2d = CLLocationCoordinate2D(latitude: (temp?.latitude)!, longitude: (temp?.longitude)!)
                location2d.removeAll()
                locationArray.removeAll()
                //mapView.removeAnnotations(mapView.selectedAnnotations)
                mapView.removeAnnotation(view.annotation!)
                addLocation2d()
                addToLocationArray()
                
            }
            
            
            func distanceBetween(location1 : CLLocation, location2 : CLLocation) -> Double
            {
                let distance = location1.distance(from: location2)
                return distance
                
            }
            
            
            func addLocation2d()
            {
                let temp = mapView.annotations
                
                for i in temp{
                    location2d.append(i.coordinate)
                }
                //location2d.append(contentsOf: temp)
            }
            
            func addToLocationArray()
            {
                let temp = mapView.annotations
                
                for i in temp{
                    var location = CLLocation()
                    location = CLLocation(latitude: i.coordinate.latitude, longitude: i.coordinate.longitude)
                    locationArray.append(location)
                }
                
            }

        }
