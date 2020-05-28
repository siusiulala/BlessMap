//
//  LoadingViewController.swift
//  BlessMpa
//
//  Created by Sam Yang on 2019/4/19.
//  Copyright © 2019 siusiulala. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoadingViewController: UIViewController {

    @IBOutlet var versionLabel: UILabel!
    var localVer: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        localVer = UserDefaults.standard.string(forKey: "DataVersion") ?? "none"
        versionLabel.text = "ver. " + localVer
//        checkVersion()
    }
    
    func checkVersion() -> Void
    {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "DataVersion")
        ref.observe(.value, with: {(snapshot) in
            let version = snapshot.value as! String
            print(version)
            if self.localVer == version
            {
                
            }
            else
            {
                self.performSegue(withIdentifier: "TempleList", sender: nil)
            }
        }
        )
    }

}
