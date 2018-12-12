//
//  LevelSelectorViewController.swift
//  AnimalFlappers
//
//  Created by Dylan McCowan on 2018-12-08.
//  Copyright © 2018 GreyCodeGroup. All rights reserved.
//

import UIKit
import MapKit

class LevelSelectorViewController: UIViewController, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MapKit View Outlet to the Storyboard
    @IBOutlet private var levelMapView : MKMapView!
    
    //Play Button - To execute the selected level
    @IBOutlet private var btnSelectLevel : UIButton!
    
    //Label to indicate which level was selected
    @IBOutlet private var lblLevelSelected : UILabel!
    
    //Level Selector Picker View
    @IBOutlet private var pvLevelSelector : UIPickerView!
    
    //Location Manager for the MapView
    private var locationMgr : CLLocationManager!
    
    /*
    This Dictionary is responsible for holding A Level Name, and a corresponsing CLLocation which will be represented on the Level selection map
    */
    private let MAP_LOCATIONS : [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 43.469397, longitude: -79.698080),
        CLLocationCoordinate2D(latitude: 43.591840, longitude: -79.647383),
        CLLocationCoordinate2D(latitude: 43.655203, longitude: -79.738558),
        CLLocationCoordinate2D(latitude: 43.680781, longitude: -79.611578),
        CLLocationCoordinate2D(latitude: 43.725906, longitude: -79.452554),
        CLLocationCoordinate2D(latitude: 43.642578, longitude: -79.387079)
    ]
    
    private let LEVEL_NAMES : [String] = [
        "Level 1 - Trafalgar"
        , "Level 2 - HMC"
        , "Level 3 - Davis"
        , "Level 4 - Toronto Pearson - T1"
        , "Level 5 - Yorkdale"
        , "Level 6 - CN Tower"]
    
    
    //This function will grab the current user details as selected
    
    //This function will change the map view to focus on a specific level
    private func focusOnSelectedLevelLocation(location : CLLocationCoordinate2D)
    {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
        levelMapView.setRegion(coordinateRegion, animated: true)
        
    }
   
    //This function call will populate the map with the unlocked levels with joining lines connecting them
    private func populateLevelLocations()
    {
        var currIndex = 0
        for(levelCoord) in MAP_LOCATIONS
        {
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = levelCoord
        dropPin.title = LEVEL_NAMES[currIndex]
        self.levelMapView.addAnnotation(dropPin)
            currIndex = currIndex + 1
        }
        
    }
    
    private func drawConnectingLines()
    {
        // Connect using a Poly line.
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()

        points.append(MAP_LOCATIONS[0])
        points.append(MAP_LOCATIONS[1])
        points.append(MAP_LOCATIONS[2])
        points.append(MAP_LOCATIONS[3])
        points.append(MAP_LOCATIONS[4])
        points.append(MAP_LOCATIONS[5])
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        
        levelMapView.addOverlay(polyline)
    }
    
    private func getLevelNameFromLevelNumber(levelNum : Int) -> String{
      return LEVEL_NAMES[levelNum]
    }
    
    private func getLevelLocationFromLevelNumber(levelNum : Int) -> CLLocationCoordinate2D{
        return MAP_LOCATIONS[levelNum]
    }
    
    // MARK: - MapView Methods
    
    
    //This function is responsible for defining the lines which will be used to connect the level points on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .black
        renderer.fillColor = .red
        renderer.lineWidth = 3.5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        lblLevelSelected.text = (view.annotation?.title)!
    }
    
    // MARK: - PickerView methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MAP_LOCATIONS.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getLevelNameFromLevelNumber(levelNum: row)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        focusOnSelectedLevelLocation(location: getLevelLocationFromLevelNumber(levelNum: row))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        levelMapView.delegate = self
        drawConnectingLines()
        populateLevelLocations()
        focusOnSelectedLevelLocation(location: MAP_LOCATIONS[0])
       lblLevelSelected.text = "Touch a level pin to select that level"

        // Do any additional setup after loading the view.
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
