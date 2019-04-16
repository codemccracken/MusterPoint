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
    
    var model_uuid: String = NSUUID().uuidString
    var codexName: String = ""
    var modelName: String = ""
    var modelOption1: String = ""
    var modelOption2: String = ""
    var modelOption3: String = ""
    var modelOption4: String = ""
    var modelNickname: String = ""
    var modelImageAddress: String = ""

    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(model_uuid, forKey: "model_uuid")
        aCoder.encode(codexName, forKey: "codexName")
        aCoder.encode(modelName, forKey: "modelName")
        aCoder.encode(modelOption1, forKey: "modelOption1")
        aCoder.encode(modelOption2, forKey: "modelOption2")
        aCoder.encode(modelOption3, forKey: "modelOption3")
        aCoder.encode(modelOption4, forKey: "modelOption4")
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
        
        if let archivedmodelOption1 = aDecoder.decodeObject(forKey: "modelOption1") as? String {
            modelOption1 = archivedmodelOption1
        }
        if let archivedmodelOption2 = aDecoder.decodeObject(forKey: "modelOption2") as? String {
            modelOption2 = archivedmodelOption2
        }
        if let archivedmodelOption3 = aDecoder.decodeObject(forKey: "modelOptions3") as? String {
            modelOption3 = archivedmodelOption3
        }
        if let archivedmodelOption4 = aDecoder.decodeObject(forKey: "modelOption4") as? String {
            modelOption4 = archivedmodelOption4
        }
        if let archivedModelNickname = aDecoder.decodeObject(forKey: "modelNickname") as? String {
            modelNickname = archivedModelNickname
        }
        if let archivedModelImageAddress = aDecoder.decodeObject(forKey: "modelImageAddress") as? String {
            modelImageAddress = archivedModelImageAddress
        }

    }
    
    
    
    init(codexName: String, modelName: String, modelOption1: String, modelOption2: String, modelOption3: String, modelOption4: String, modelNickname: String, modelImageAddress: String) {
        super.init()
        
        //self.model_uuid = model_uuid
        self.codexName = codexName
        self.modelName = modelName
        self.modelOption1 = modelOption1
        self.modelOption2 = modelOption2
        self.modelOption3 = modelOption3
        self.modelOption4 = modelOption4
        self.modelNickname = modelNickname
        self.modelImageAddress = modelImageAddress

    }
    
}
    

