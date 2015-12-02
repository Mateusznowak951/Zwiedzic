//
//  ServiceHelper.swift
//  AddressMap
//
//  Created by md arifuzzaman on 7/16/14.
//  Copyright (c) 2014 md arifuzzaman. All rights reserved.
//

import Foundation
class ServiceHelper{
    
    // klasa sluzaca do pobierania danych na podstawie zapytania http 
    // zapytanie jest wykonywane na podstawie adresu url
    
    func getServiceHandle(afterDownload:([SearchModel]) -> Void ,url:String){
        
        // zamiana zmiennej typu string na adres url
        let nsURL:NSURL = NSURL(string: url)!;
        print(url, terminator: "");
        let urlRequest = NSMutableURLRequest(URL: nsURL);
        urlRequest.timeoutInterval = 30.0;
        urlRequest.HTTPMethod = "GET";
        let queue:NSOperationQueue = NSOperationQueue.mainQueue();
        
        // wyslanie zapytania
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue, completionHandler: { response, data, error in
            print(response, terminator: "");
            print(data, terminator: "");
            // do zmiennej data zostaly zapisane dane odnosnie pobliskich obiektow
            if(data!.length > 0){
                var publishData:[SearchModel] = [SearchModel]();
                // serializowanie danych przy uzyciu JSON
                let jsonObject:AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments);
                print(jsonObject, terminator: "");
                if(jsonObject.isKindOfClass(NSDictionary)){
                    // zapisane dane w formacie JSON
                    let datas =  jsonObject.valueForKey("results")! as! NSArray;
                    
                    // dla kazdego znalezionego obiektu pobierz informacje i zapisz do publishData
                    for dictData : AnyObject in datas{
                        let dictEach = dictData as! NSDictionary;
                        let name = dictEach.valueForKey("name")! as! NSString;
                        let icon = dictEach.valueForKey("icon")! as! String;
                        
                        print(name);
                        print(icon);
                        
                        let gematries = dictEach.valueForKey("geometry")! as! NSDictionary;
                        let locations:AnyObject = gematries.valueForKey("location")!;
                        let lon = locations.valueForKey("lng")! as! Double;
                        let lat = locations.valueForKey("lat")! as! Double;
  
                        let tmp : AnyObject? = dictEach.valueForKey("vicinity");
                        if(tmp != nil)
                        {
                            let address = tmp as! String;
                            let searchModel:SearchModel = SearchModel(name: name as String, icon: icon, lon: lon, lat: lat,address:address);
                            // dodaj nowy znaleziony obiekt
                            publishData.append(searchModel);
                        }
                    }
                    // Debug
                    print(publishData, terminator: "");
                    for  item in publishData{
                        print(item.name, terminator: "");
                        print(item.icon, terminator: "");
                        print(item.lat, terminator: "");
                        print(item.lon, terminator: "");
                    }
                    // Wykonaj funkcje przekazana w afterDownload z parameterm publishData
                    afterDownload(publishData);
                }
            }
            else{
                    //error cought here
            }
            
        });
    }
}