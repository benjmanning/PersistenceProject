//
//  CoreDataResultsObserver.swift
//  PersistenceProject
//
//  Created by Ben Manning on 07/07/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit
import CoreData


class CoreDataResultsObserver<ManagedObj: LinkedManagedObject>: ObservableList<ManagedObj.LinkedModel> {
  
  private var resultsUpdater: CoreDataResultsObserverUpdater<ManagedObj.LinkedModel>?
  private var linkedModelResults: [ManagedObj.LinkedModel] = []
  
  override var results: [ManagedObj.LinkedModel] { return linkedModelResults }

  override var delegate: ObservableListDelegate? {
    get { return fetchedResultsControllerAdapter.delegate }
    set { fetchedResultsControllerAdapter.delegate = newValue }
  }
  
  private let fetchedResultsController: NSFetchedResultsController<ManagedObj>
  private let fetchedResultsControllerAdapter = CoreDataResultsObserverAdapter<ManagedObj>()
  private let includeParentRelations: Bool
  
  init(
    managedObjectContext: NSManagedObjectContext,
    includeParentRelations: Bool = false,
    sortDescriptors: [NSSortDescriptor] = []) {
    
    self.includeParentRelations = includeParentRelations
    
    let fetchRequest: NSFetchRequest<ManagedObj> = ManagedObj.fetchRequest() as! NSFetchRequest<ManagedObj>
    fetchRequest.sortDescriptors = sortDescriptors
    
    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                          managedObjectContext: managedObjectContext,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
    fetchedResultsController.delegate = fetchedResultsControllerAdapter
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      Logger.e("Error starting fetcher: \(error)")
    }
    
    super.init()
    
    linkedModelResults = fetchedResultsController.fetchedObjects?.map { convertToModel($0) } ?? []
    setupNotifiers()
  }
  
  func invalidate() {
    fetchedResultsController.delegate = nil
  }
  
  func setupNotifiers() {
    weak var weakself = self
    fetchedResultsControllerAdapter.changeNotifier = { (obj, indexPath, type, newIndexPath) in
      weakself?.changeHandler(obj: obj, indexPath: indexPath, type: type, newIndexPath: newIndexPath)
    }
    fetchedResultsControllerAdapter.beginNotifier = {
      self.changeBeginHandler()
    }
    fetchedResultsControllerAdapter.endNotifier = {
      self.changeEndHandler()
    }
  }
  
  func changeHandler(obj: ManagedObj?, indexPath: IndexPath?, type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    if type == .update, let newIndexPath = newIndexPath, let obj = obj {
      // This 'if' is not strictly necessary but having it will turn an array delete/insert into a replace
      resultsUpdater?.updateResult(result: convertToModel(obj), at: newIndexPath.row)
    } else {
      if let newIndexPath = newIndexPath, let obj = obj {
        resultsUpdater?.addResult(result: convertToModel(obj), at: newIndexPath.row)
      }
      if let indexPath = indexPath {
        resultsUpdater?.deleteResult(at: indexPath.row)
      }
    }
  }
  
  func changeBeginHandler() {
    resultsUpdater = CoreDataResultsObserverUpdater(results: results)
  }
  
  func changeEndHandler() {
    guard let resultsUpdater = resultsUpdater else {
      Logger.e("Unexpected resultsUpdater nil")
      return
    }
    
    linkedModelResults = resultsUpdater.buildResults()
    self.resultsUpdater = nil
  }
  
  func convertToModel(_ managedObj: ManagedObj) -> ManagedObj.LinkedModel {
    return managedObj.convertToModel(includeParentRelations: includeParentRelations, includeChildRelations: false)
  }
}
