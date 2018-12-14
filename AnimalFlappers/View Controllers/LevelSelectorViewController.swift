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
    
    //Specify the level names for the game 
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
        let del = UIApplication.shared.delegate as! AppDelegate
        
        var currIndex = 0
        for(levelCoord) in MAP_LOCATIONS
        {
            if(currIndex <= (del.PL_LEVEL - 1)){
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = levelCoord
                dropPin.title = LEVEL_NAMES[currIndex]
                self.levelMapView.addAnnotation(dropPin)
                    currIndex = currIndex + 1
                print("Index: \(del.PL_LEVEL)!")
            }
        }
    }
    
    //Draw the connecting lines between the unlocked levels on the map as a PolyLine
    private func drawConnectingLines()
    {
        // Connect using a Poly line.
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        let del = UIApplication.shared.delegate as! AppDelegate

        for index in 0..<del.PL_LEVEL {
        points.append(MAP_LOCATIONS[index])
            print(index)
        }
        print(del.PL_LEVEL)
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        
        levelMapView.addOverlay(polyline)
    }
    
    //Returns the level name for an associated level number
    private func getLevelNameFromLevelNumber(levelNum : Int) -> String{
      return LEVEL_NAMES[levelNum]
    }
    
    //Returns the location coordinate from the collection of levels based on what level is asked
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
    
    //Show the button to play the level and game and update the text indicating which level has been selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        lblLevelSelected.text = (view.annotation?.title)!
        btnSelectLevel.isHidden = false
    }
    
    // MARK: - PickerView methods
    //Only need 1 component in the picker view for level selection
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //We only want to have as many rows as there have been unlocked levels for the player
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let del = UIApplication.shared.delegate as! AppDelegate

        return del.PL_LEVEL
    }
    
    //Shows the level names based on the selected row index
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getLevelNameFromLevelNumber(levelNum: row)
        
    }
    
    //Focus the map on the location of the currently selected level
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        focusOnSelectedLevelLocation(location: getLevelLocationFromLevelNumber(levelNum: row))
    }
    
    //Hide the level select button if there is no level pin currently selected
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        lblLevelSelected.text = (view.annotation?.title)!
        btnSelectLevel.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the delegate to this own self class
        levelMapView.delegate = self
        btnSelectLevel.isHidden = true
        
        //Draw connecting line and map pins on the map as appropriate for currently selected player
        drawConnectingLines()
        populateLevelLocations()
        focusOnSelectedLevelLocation(location: MAP_LOCATIONS[0])
       lblLevelSelected.text = "Touch a level pin to select that level"

        // Do any additional setup after loading the view.
    }

}
