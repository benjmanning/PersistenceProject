//
//  CoreDataResultObserver.swift
//  PersistenceProject
//
//  Created by Ben Manning on 25/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import CoreData

class CoreDataResultObserver<ManagedObj: LinkedManagedObject>: ObservableObj<ManagedObj.LinkedModel> {
  
  private var observed: ManagedObj.LinkedModel?
  
  override var result: ManagedObj.LinkedModel? {
    return observed
  }
  
  override var delegate: ObservableObjDelegate? {
    get { return fetchedResultControllerAdapter.observerDelegate }
    set { fetchedResultControllerAdapter.observerDelegate = newValue }
  }

  private let fetchedResultsController: NSFetchedResultsController<ManagedObj>
  
  private let fetchedResultControllerAdapter = CoreDataResultObserverAdapter<ManagedObj>()
  
  private let includeChildRelations: Bool
  private let includeParentRelations: Bool

  init(managedObjectContext: NSManagedObjectContext,
       predicate: NSPredicate,
       includeChildRelations: Bool = true,
       includeParentRelations: Bool = true) {
    
    self.includeChildRelations = includeChildRelations
    self.includeParentRelations = includeParentRelations

    let fetchRequest: NSFetchRequest<ManagedObj> = ManagedObj.fetchRequest() as! NSFetchRequest<ManagedObj>
    
    fetchRequest.sortDescriptors = []
    
    fetchRequest.predicate = predicate
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                          managedObjectContext: managedObjectContext,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultControllerAdapter
    
    super.init()
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      Logger.e("Error starting fetcher: \(error)")
    }
    
    
    observed = convertToModel(managedObj: fetchedResultsController.fetchedObjects?.first)
    
    weak var weakself = self
    fetchedResultControllerAdapter.changeNotifier = { (t, m) in
      weakself?.resultsChangeHandler(type: t, managedObj: m)
    }
  }
  
  func invalidate() {
    fetchedResultsController.delegate = nil
  }
  
  func resultsChangeHandler(type: NSFetchedResultsChangeType, managedObj: ManagedObj) {
    if type == .delete {
      observed = nil
    } else {
      observed = convertToModel(managedObj: managedObj)
    }
  }
  
  func convertToModel(managedObj: ManagedObj?) -> ManagedObj.LinkedModel? {
    return managedObj?.convertToModel(
      includeParentRelations: includeParentRelations,
      includeChildRelations: includeChildRelations)
  }
}
