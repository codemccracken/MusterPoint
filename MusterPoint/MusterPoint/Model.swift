//
//  Model.swift
//  MusterPoint
//
//  Created by Eric McCracken on 11/3/18.
//  Copyright © 2018 Eric McCracken. All rights reserved.
//

import UIKit

class Model: NSObject, NSCoding {
    
    // Declair variables
    // Unique Identifier of type uuid
    var model_uuid: String = NSUUID().uuidString
    // Name of item
    var codexName: String = ""
    // Line for item stats
    var modelName: String = ""
    // Line for item Rules
    var modelOptions: String = ""
    // Item Power Cost
    var modelNickname: String = ""
    // Item Point Cost
    var modelImageAddress: String = ""
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(model_uuid, forKey: "model_uuid")
        aCoder.encode(codexName, forKey: "codexName")
        aCoder.encode(modelName, forKey: "modelName")
        aCoder.encode(modelOptions, forKey: "modelOptions")
        aCoder.encode(modelNickname, forKey: "modelNickname")
        aCoder.encode(modelImageAddress, forKey: "modelImageAddress")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let archivedUuid = aDecoder.decodeObject(forKey: "model_uuid") as? String {
            model_uuid = archivedUuid
        }
        
        if let archivedCodexName = aDecoder.decodeObject(forKey: "codexName") as? String {
            codexName = archivedCodexName
        }
        
        if let archivedModelName = aDecoder.decodeObject(forKey: "modelName") as? String {
            modelName = archivedModelName
        }
        
        if let archivedmodelOptions = aDecoder.decodeObject(forKey: "modelOptions") as? String {
            modelOptions = archivedmodelOptions
        }
        
        if let archivedModelNickname = aDecoder.decodeObject(forKey: "modelNickname") as? String {
            modelNickname = archivedModelNickname
        }
        if let archivedModelImageAddress = aDecoder.decodeObject(forKey: "itemPointCost") as? String {
            modelImageAddress = archivedModelImageAddress
        }
    }
    
    
    
    init(codexName: String, modelName: String, modelOptions: String, modelNickname: String, modelImageAddress: String) {
        super.init()
        
        self.codexName = codexName
        self.modelName = modelName
        self.modelOptions = modelOptions
        self.modelNickname = modelNickname
        self.modelImageAddress = modelImageAddress
    }
    
}
    

