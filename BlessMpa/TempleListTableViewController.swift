//
//  TempleListTableViewController.swift
//  BlessMpa
//
//  Created by Sam Yang on 2019/3/23.
//  Copyright © 2019 siusiulala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData

class TempleTableViewCell: UITableViewCell {
    
    @IBOutlet var TempleNameLabel: UILabel!
}

class TempleListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var temples: [TempleMO] = []
    var fetchResultController: NSFetchedResultsController<TempleMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//deleteAllRecords()
        downloadTempleData()
//        fetchDataFromLocal()
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return temples.filter({ $0.god=="福德正神"}).count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "templeListItem", for: indexPath) as! TempleTableViewCell

        let temple = temples.filter({ $0.god=="福德正神"})[indexPath.row]
        cell.TempleNameLabel.text = temple.name
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func downloadTempleData() -> Void
    {
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "DataVersion")
        ref.observe(.value, with: {(snapshot) in
            var version = snapshot.value as! String
            print(version)
        }
        )
//        ref = Database.database().reference(withPath: "TempleData")
//        ref.queryOrderedByKey().observe(.value, with: { (snapshot) in
////            var newItems: [TempleMO] = []
//            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//
//
//            }
//            for item in snapshot.children {
//                let temple = Temple(snapshot: item as! DataSnapshot)
//
//
//                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
//                    var templeData = TempleMO(context: appDelegate.persistentContainer.viewContext)
//                    templeData.key = temple.key
//                    templeData.name = temple.name
//                    templeData.god = temple.god
//                    templeData.type = temple.type
//                    templeData.country = temple.country
//                    templeData.address = temple.address
//                    templeData.phone = temple.phone
//                    templeData.other = temple.other
//                    templeData.posX = temple.posX
//                    templeData.posY = temple.posY
//
//                    appDelegate.saveContext()
//
////                    newItems.append(templeData)
//                }
//
//
//            }
////            self.temples = newItems
////            self.tableView?.reloadData()
//            self.fetchDataFromLocal()
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    
    func fetchDataFromLocal()
    {
        let fetchRequest: NSFetchRequest<TempleMO> = TempleMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "key", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    temples = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?, for type:
        NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with:.fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            temples = fetchedObjects as! [TempleMO]
        }
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Temple")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
