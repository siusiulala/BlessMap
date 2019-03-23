//
//  ViewController.swift
//  BlessMpa
//
//  Created by Sam Yang on 2019/3/23.
//  Copyright © 2019 siusiulala. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    var res: String = ""
    var count: Int = 0
    var temples: [Temple] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var ref: DatabaseReference!
        print("Before query")
        ref = Database.database().reference(withPath: "TempleData")
        ref.queryOrderedByKey().observe(.value, with: { (snapshot) in
            var newItems: [Temple] = []
            for item in snapshot.children {
                let temple = Temple(snapshot: item as! DataSnapshot)
                self.count += 1
                newItems.append(temple)
            }
            self.temples = newItems
//            self.collectionView?.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        print("res: \(count)")
        print("End query")
    }


}

