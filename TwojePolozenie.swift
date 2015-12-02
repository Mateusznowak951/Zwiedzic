//
//  TwojePolozenie.swift
//  Warto_Zwiedzic
//
//  Created by Artur on 04/11/15.
//  Copyright © 2015 Artur. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation



class TwojePolozenie: UIViewController, UITextFieldDelegate,
UITableViewDataSource, CLLocationManagerDelegate, UITableViewDelegate {
    
    let locationManager = CLLocationManager()
    var center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0) // tutaj zapisywane sa wspolrzedne geograficzne aktulanej lokalizacji uzytkownika
    
    let apiKey = "AIzaSyDm-4Vou6hHU0Vx5Jd3hXaZIb0GFMxuuRY"
    
    var autoCompleteTableView: UITableView;
    var autoCompleteDataSource:Array<String> = [];
    var mapData:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var searchBy:String = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        autoCompleteTableView = UITableView(frame: CGRectMake(30, 200, 295, 500), style: UITableViewStyle.Plain);
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation() // rozpocznij aktualizacje lokalizacji
        
        self.drawTable() // narysuj tabele
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last // pobierz ostatnia znana lokalizacje uzytkownika
        
        center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude) // przelicz ja na wsppolrzedne w wymiarze 2D
        
        /* Wyswietl szerokosc i dlugosc geograficzna */
        /*
        let latitude:String = String(format:"%f", center.latitude);
        let longitude:String = String(format:"%f", center.longitude)
        let alert = UIAlertController(title: "Twoje współrzędne położenia:", message:"Lat: "+latitude+" Long: "+longitude, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
        */
        /* Wyswietl szerokosc i dlugosc geograficzna */
        //self.locationManager.stopUpdatingLocation() // zakoncz aktualizowanie lokalizacji
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    
    func drawTable()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("dataLoaded:"), name: "DataLoaded", object: nil);
        autoCompleteTableView.dataSource = self;
        autoCompleteTableView.delegate = self;
        autoCompleteTableView.backgroundColor = UIColor.clearColor();
        autoCompleteTableView.separatorColor = UIColor.clearColor();
        
        autoCompleteDataSource.append("Restaurant");
        autoCompleteDataSource.append("Airport");
        autoCompleteDataSource.append("Atm");
        autoCompleteDataSource.append("Bank");
        autoCompleteDataSource.append("Church");
        autoCompleteDataSource.append("Hospital");
        autoCompleteDataSource.append("Mosque");
        autoCompleteDataSource.append("Movie_theater");
        autoCompleteDataSource.append("Museum");
        
        autoCompleteTableView.hidden = false; // pokaz tabele // hidden znaczy ukryj
        self.view.addSubview(autoCompleteTableView);
    }
    
    func dataLoaded(userData:[SearchModel]){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        let mapController:WynikPolozenia = storyBoard.instantiateViewControllerWithIdentifier ("wynikPolozenia") as! WynikPolozenia;
        mapController.mapData = userData; // pobierz dane na temat pobliskich obietkow
        mapController.searchBy = self.searchBy; // pobierz obiekt ktory ma zostac znaleziony
        self.navigationController?.showViewController(mapController, sender: self); // przelacz na mape
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
 
        self.locationManager.delegate = self
            
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        searchBy = self.autoCompleteDataSource[indexPath.row]; // pobierz obiekt ktory ma zostac znaleziony
        let searchkey = self.autoCompleteDataSource[indexPath.row].lowercaseString; // pobierz obiekt ktory ma zostac znaleziony w postaci malych znakow
        
        let serviceHelper = ServiceHelper(); // obiekt klasy sluzacy do pobierania lokalizacji pobliskich obietkow
        let dynamicURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(center.latitude),\(center.longitude)&radius=50000&types=\(searchkey)&sensor=true&key=\(apiKey)" // adres URL wedlug ktory szuka pobliskie obiekty
        print(dynamicURL, terminator: "");
        serviceHelper.getServiceHandle(self.dataLoaded, url: dynamicURL); // wykonaj zapytanie http i wynik przekaz do funkcji dataLoaded
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.autoCompleteDataSource.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:UITableViewCell?;
        let cellString = "autocompletecell";
        if let cellToUse = cell{
            
        }
        else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellString);
        }
        
        let data = autoCompleteDataSource[indexPath.row];
        var img:UIImage?;
        
        if(data == "Restaurant"){
            img = UIImage(named: "restaurent.jpg");
            
        }
        else if(data == "Airport"){
            img = UIImage(named: "airport.png");
        }
        else if(data == "Hospital"){
            img = UIImage(named: "hospital.png");
        }
        else if(data == "Mosque"){
            img = UIImage(named: "mosque.png");
        }
        else if(data == "Church"){
            img = UIImage(named: "church-icon.png");
        }
        else if(data == "Atm"){
            img = UIImage(named: "atm.png");
        }
        else if(data == "Bank"){
            img = UIImage(named: "bank.png");
        }
        else if(data == "Movie_theater"){
            img = UIImage(named: "cinema.png");
        }
        else if(data == "Museum"){
            img = UIImage(named: "cinema.png");
        }
        else{
            img = UIImage(named: "noimage.gif");
        }
    
        cell!.imageView!.image = img!;
        cell!.textLabel!.text = data;
        cell!.backgroundColor = UIColor(red: 100, green: 100, blue: 190, alpha: 0.5);
        
        return cell!;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    

