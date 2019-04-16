//
//  CollectionTableViewController.swift
//  MusterPoint
//
//  Created by Eric McCracken on 11/3/18.
//  Copyright © 2018 Eric McCracken. All rights reserved.
//

import UIKit


class CollectionTableViewController: UITableViewController, AddModelViewControllerDelegate, EditModelViewControllerDelegate {

    // Mark: - Declare Variables
    var models = [Model]()
    var sortedModels = [SortedModel]()
    let CellIdentifier = "Cell Identifier"
    var selection: Model?
    //var selection: SortedModel?
    
    
    
    // Mark: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Collection"
        
        // Register Class
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        // Create Add Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addModel))
        
        // Create Edit Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editModel))
        
        
    }

    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load Models
        loadModels()
        
        // Sort Models
        sortedModels = sortModels()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.text = sortedModels[section].codexName
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    @objc func handleOpenClose() {
        print("Open Close button pressed")
        //tableview.deleteRows
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sortedModels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return sortedModels[section].models.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath) as! modelCellTableViewCell
        
        
        // Fetch Model
        
        let model = sortedModels[indexPath.section]
        
        // Configure Table View Cell
        cell.modelNickname?.text = model.models[indexPath.row].modelNickname
        cell.modelNickname.textColor = UIColor(red:0.24, green:0.31, blue:0.35, alpha:1.0)
        cell.modelName?.text = model.models[indexPath.row].modelName
        cell.codexName?.text = model.models[indexPath.row].codexName
        cell.modelOption1?.text = model.models[indexPath.row].modelOption1
        cell.modelOption2?.text = model.models[indexPath.row].modelOption2
        cell.modelOption3?.text = model.models[indexPath.row].modelOption3
        cell.modelOption4?.text = model.models[indexPath.row].modelOption4
        cell.modelName.adjustsFontSizeToFitWidth = true
        cell.modelOption1.adjustsFontSizeToFitWidth = true
        cell.modelOption2.adjustsFontSizeToFitWidth = true
        cell.modelOption3.adjustsFontSizeToFitWidth = true
        cell.modelOption4.adjustsFontSizeToFitWidth = true
        let fileManager = FileManager.default
        let imageName = model.models[indexPath.row].codexName + model.models[indexPath.row].modelName + model.models[indexPath.row].modelOption1
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            cell.modelImage.image = UIImage(contentsOfFile: imagePath)

        }else{
            //print("No Image found")
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // identify UUID of mode to be removed
            let removeUUID = sortedModels[indexPath.section].models[indexPath.row].model_uuid
            // remove everything from models that matches that UUID
            models = models.filter { (model) -> Bool in
                return model.model_uuid != removeUUID
            }
            
            // Delete Model from SortedModels
            sortedModels[indexPath.section].models.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .left)
            
            
            // Save Changes and resort models
            saveModels()
            sortedModels = sortModels()
            // Reload table data
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor(red:0.24, green:0.31, blue:0.35, alpha:1.0)
//        cell.textLabel?.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("accessoryButton pressed")
        // Fetch model
        
        let model = sortedModels[indexPath.section].models[indexPath.row]
        
        //print(model)
        
        // Update Selection
        selection = model
        
        // perform Segue
        performSegue(withIdentifier: "EditModelViewController", sender: self)
    }
    
    // MARK: - Save, Load, and Sort Models
    private func saveModels() {
        if let filePath = pathForModels() {
            NSKeyedArchiver.archiveRootObject(models, toFile: filePath)
            
        }
        
    }
    
    private func loadModels() {
        if let filePath = pathForModels(), FileManager.default.fileExists(atPath: filePath) {
            if let archivedModels = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Model] {
                models = archivedModels
                
            }
        }
    }
    
    func sortModels() -> [SortedModel] {
        print("sort Model function started")
        // check to see if a section is empty and if it is delete the section
        
        
        var presortedModels = models
        var sortedModels: [SortedModel] = []
        while !presortedModels.isEmpty {
            guard let referenceModel = presortedModels.first else {
                print("all models are sorted.")
                return []
            }
            
            let filteredModels = presortedModels.filter { (model) -> Bool in
                return model.codexName == referenceModel.codexName
            }
            
            presortedModels.removeAll { (model) -> Bool in
                return model.codexName == referenceModel.codexName
            }
            let append = SortedModel(codexName: referenceModel.codexName, models: filteredModels)
            sortedModels.append(append)
        }
        
        return sortedModels.sorted {$0.codexName < $1.codexName}
    }
    
    // MARK: - Helper Methods
    private func pathForModels() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("sortedModels.plist")?.path
        }
        
        return nil
    }
    
    // MARK: - AddModel button pushed
    @objc func addModel(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddModelViewController", sender: self)
    }
    
    // MARK: - EditModel button pushed
    @objc func editModel(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    // MARK: - AddModelViewController Delegate Methods
    func controller(controller: AddModelViewController, didSaveModelWithCodex codexName: String, andModelName modelName: String, andModelOption1 modelOption1: String, andModelOption2 modelOption2: String, andModelOption3 modelOption3: String, andModelOption4 modelOption4: String, andModelNickname modelNickname: String, andModelImageAddress modelImageAddress: String) {
        
        //Create Model
        let model = Model(codexName: codexName, modelName: modelName, modelOption1: modelOption1, modelOption2: modelOption2, modelOption3: modelOption3, modelOption4: modelOption4, modelNickname: modelNickname, modelImageAddress: modelImageAddress)
        
        // add Model to Models
        models.append(model)
        
        // add Row to Table View
        //tableView.insertRows(at: [NSIndexPath(row: (models.count - 1), section: 0) as IndexPath], with: .none)
        
        
        // Save Models
        saveModels()
        sortedModels = sortModels()
        tableView.reloadData()
        
    }
    
    // MARK: - EditModelViewController Delegate Methods
    func controller(controller: EditModelViewController, didUpdateModel model: Model ) {
        // Fetch Index for Model
        if let index = models.index(of: model) {
            // Update Table View
            tableView.reloadRows(at: [NSIndexPath(row: index, section: 0) as IndexPath], with: .fade)
            
            // save models
            saveModels()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddModelViewController" {
            if let navigationController = segue.destination as? UINavigationController,
                let addModelViewController = navigationController.viewControllers.first as? AddModelViewController {
                addModelViewController.delegate = (self as AddModelViewControllerDelegate)
            }
        } else if segue.identifier == "EditModelViewController" {
            let editModelViewController = segue.destination as? EditModelViewController
            let model = selection
            editModelViewController?.delegate = self as EditModelViewControllerDelegate
            editModelViewController?.model = model
        }
        
        
    }
    
    
    
    
}
