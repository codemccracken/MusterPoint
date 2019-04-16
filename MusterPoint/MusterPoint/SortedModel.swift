//
//  SortedModel.swift
//  MusterPoint
//
//  Created by Eric McCracken on 11/25/18.
//  Copyright © 2018 Eric McCracken. All rights reserved.
//

import UIKit

class SortedModel: NSObject, NSCoding {

    // Declair variables
    
    var codexName: String = ""
    var models: [Model] = []
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(codexName, forKey: "codexName")
        aCoder.encode(models, forKey: "models")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let archivedCodexName = aDecoder.decodeObject(forKey: "codexName") as? String {
            codexName = archivedCodexName
        }
        
        if let archivedModels = aDecoder.decodeObject(forKey: "models") as? [Model] {
            models = archivedModels
        }
    }
    
    init(codexName: String, models: [Model]) {
        self.codexName = codexName
        self.models = models
    }

}
