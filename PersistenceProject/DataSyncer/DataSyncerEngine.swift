//
//  DataSyncerEngine.swift
//  PersistenceProject
//
//  Created by Ben Manning on 21/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

import CoreData

class DataSyncerEngine: NSObject {
  
  enum SyncError: Error {
    case duplicateDtoId
  }
  
  typealias ModelObjLookup<ModelObj: Any> = [Int64: ModelObj]
    
  func performSync<Dto: DataSyncableDto>(
    dtos: [Dto],
    modelObjs: [Dto.ModelObj],
    store: Dto.Store) throws where Dto.ModelObj.Store == Dto.Store {
    
    // Build a dictionary of managed objects for faster lookup
    let modelObjDic = try buildModelObjDic(modelObjs: modelObjs)
    
    // Remembers managed objects not found in the DTO's (need deleting)
    var toDeletePersistedObjs = modelObjDic
    
    // Update or Insert the data in CoreData
    for dto in dtos {
      process(
        dto: dto,
        modelObjDic: modelObjDic,
        store: store)
      
      toDeletePersistedObjs.removeValue(forKey: dto.syncableId)
    }
    
    // Delete any objects from CoreData that were not in the input
    for persistedObj in toDeletePersistedObjs.values {
      persistedObj.delete(from: store)
    }
  }
  
  private func process<Dto: DataSyncableDto>(
    dto: Dto,
    modelObjDic: ModelObjLookup<Dto.ModelObj>,
    store: Dto.Store) {
    
    if let modelObj = modelObjDic[dto.syncableId] {
      if dto.needsUpdate(with: modelObj) {
        dto.update(with: store)
      }
    } else {
      dto.insert(into: store)
    }
  }
  
  private func buildModelObjDic<ModelObj: DataSyncableModelObj>(
    modelObjs: [ModelObj]) throws -> ModelObjLookup<ModelObj> {
    
    var dic = ModelObjLookup<ModelObj>()
    
    for modelObj in modelObjs {
      let id = modelObj.syncableId
      
      if dic[id] != nil {
        throw SyncError.duplicateDtoId
      }
      
      dic[id] = modelObj
    }
    
    return dic
  }
}
