//
//  ManagedObjectObserver.swift
//  PersistenceProject
//
//  Created by Ben Manning on 07/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class ManagedObjectObserver<ManagedObj: LinkedManagedObject>: ObservableObj<ManagedObj.LinkedModel> {
  
  private var observed: ManagedObj.LinkedModel?
  
  override var result: ManagedObj.LinkedModel? {
    return observed
  }
  
  private let managedObj: ManagedObj?
  
  init(managedObj: ManagedObj?) {
    self.managedObj = managedObj
    
    super.init()
    
    self.observed = managedObj?.convertToModel()

    if let moc = managedObj?.managedObjectContext {
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(managedObjectChange(notification:)),
                                             name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                             object: moc)
    }
  }
  
  deinit {
    if let moc = managedObj?.managedObjectContext {
      NotificationCenter.default.removeObserver(self,
                                                name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                                object: moc)
    }
  }
  
  @objc private func managedObjectChange(notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    
    guard let managedObj = managedObj else { return }
    
    // The item was updated
    if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
      if updates.contains(managedObj) {
        observed = managedObj.convertToModel()
        self.delegate?.observableObjUpdate()
      }
    }
    
    // The item was deleted
    if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
      if deletes.contains(managedObj) {
        observed = nil
        self.delegate?.observableObjDelete()
      }
    }
  }
}
