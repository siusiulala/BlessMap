//
//  Temple.swift
//  BlessMpa
//
//  Created by Sam Yang on 2019/3/23.
//  Copyright © 2019 siusiulala. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Temple {
    let key: String
    let name: String
    let god: String?
    let posX: String?
    let posY: String?
    let other: String?
    let address: String?
    let type: String?
    let country: String?
    let phone: String?
    let ref: DatabaseReference?
    init(name: String, type: String?, god: String?, posX: String?, posY: String?, address: String?, country: String?, phone: String?, other: String?, key: String = "") {
        self.key = key
        self.name = name
        self.type = type
        self.god = god
        self.posX = posX
        self.posY = posY
        self.address = address
        self.country = country
        self.phone = phone
        self.other = other
        self.ref = nil
    }
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["寺廟名稱"] as! String
        god = snapshotValue["主祀神祇"] as? String
        country = snapshotValue["行政區"] as? String
        address = snapshotValue["地址"] as? String
        type = snapshotValue["教別"] as? String
        phone = snapshotValue["電話"] as? String
        other = snapshotValue["其他"] as? String
        posX = snapshotValue["WGS84X"] as? String
        posY = snapshotValue["WGS84Y"] as? String
        ref = snapshot.ref
    }
    func toAnyObject() -> Any {
        return [
            "name": name,
            "god": god,
            "country": country,
            "address": address,
            "type": type,
            "phone": phone,
            "other": other!,
            "posX": posX,
            "posY": posY
        ]
    }
}
