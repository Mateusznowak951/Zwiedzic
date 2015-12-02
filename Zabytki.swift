//
//  Zabytki.swift
//  Warto_Zwiedzic
//
//  Created by Artur on 01/12/15.
//  Copyright © 2015 Artur. All rights reserved.
//

import Foundation

import UIKit

class Zabytki: UITableViewController {
    
    
    var listaZabytki = [
    ["title":"Wawel"],
    ["title":"Muzeum Narodowe"],
    ["title":"Kosciol Mariacki"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaZabytki.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mycell") as! ZabytkiTableViewCell
        cell.title.text = listaZabytki[indexPath.item]["title"]
        
        return cell
    }
}