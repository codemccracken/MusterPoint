//
//  EditModelViewController.swift
//  MusterPoint
//
//  Created by Eric McCracken on 11/3/18.
//  Copyright © 2018 Eric McCracken. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol EditModelViewControllerDelegate {
    func controller(controller: EditModelViewController, didUpdateModel model: Model)
}

class EditModelViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var codexNameTextField: UITextField!
    @IBOutlet var modelNameTextField: UITextField!
    @IBOutlet var modelOptionsTextField: UITextField!
    @IBOutlet var modelNicknameTextField: UITextField!
    @IBOutlet var modelImage: UIImageView!
    
    var model: Model!
    var delegate: EditModelViewControllerDelegate?
    
    var newPic: Bool? = false
    
    @IBAction func importImage(sender: AnyObject){
        
        let myAlert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.camera
            image.mediaTypes = [kUTTypeImage as String]
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
            self.newPic = true
        }
        let cameraRollAction = UIAlertAction(title: "Photo Library", style: .default){ (action) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.mediaTypes = [kUTTypeImage as String]
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
            self.newPic = false
        }
        
        myAlert.addAction(cameraAction)
        myAlert.addAction(cameraRollAction)
        self.present(myAlert, animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        // Populate Text Fields
        codexNameTextField.text = model.codexName
        modelNameTextField.text = model.modelName
        modelOptionsTextField.text = model.modelOptions
        modelNicknameTextField.text = model.modelNickname
        
        let fileManager = FileManager.default
        let imageName = model.codexName + model.modelName + model.modelOptions
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            print(modelImage.image?.imageOrientation)
            modelImage.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image found")
        }
        
    }
    
    // MARK: Actions
    @objc func save(sender: UIBarButtonItem) {
        if let codexName = codexNameTextField.text, let modelName = modelNameTextField.text, let modelOptions = modelOptionsTextField.text, let modelNickname = modelNicknameTextField.text {
            
            // Update model
            model.codexName = codexName
            model.modelName = modelName
            model.modelOptions = modelOptions
            model.modelNickname = modelNickname
            
            // if image is not blank save it
            if (modelImage != nil){
                //print("Image is not nil")
                //create an instance of the FileManager
                let fileManager = FileManager.default
                // set image name
                
                let imageName = model.codexName + model.modelName + model.modelOptions
                //print(imageName)
                //get the image path
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                //get the image we took with camera
                let image = modelImage.image!
                //get the PNG data for this image
                let data = image.pngData()
                //store it in the document directory
                fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
                let modelImageAddress = imagePath
                print(modelImageAddress)
            } else {
                let modelImageAddress = ""
            }
            
            
            
            //Notify Delegate
            delegate?.controller(controller: self, didUpdateModel: model)
            
            // Pop View Controller
            navigationController?.popViewController(animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            modelImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    

}
