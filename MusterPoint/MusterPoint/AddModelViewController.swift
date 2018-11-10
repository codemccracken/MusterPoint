//
//  AddModelViewController.swift
//  MusterPoint
//
//  Created by Eric McCracken on 11/3/18.
//  Copyright © 2018 Eric McCracken. All rights reserved.
//

protocol AddModelViewControllerDelegate {
    func controller(controller: AddModelViewController, didSaveModelWithCodex codexName: String, andModelName modelName: String, andModelOptions modelOptions: String, andModelNickname modelNickname: String, andModelImageAddress modelImageAddress: String)
}

import UIKit
import MobileCoreServices

class AddModelViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var codexNameTextField: UITextField!
    @IBOutlet var modelNameTextField: UITextField!
    @IBOutlet var modelOptionsTextField: UITextField!
    @IBOutlet var modelNicknameTextField: UITextField!
    @IBOutlet var modelImage: UIImageView!
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            modelImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    var modelImageAddress = ""
    var delegate: AddModelViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modelImage.layer.borderWidth = 2
        modelImage.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
        
    
    
    // Mark: Actions
    @IBAction func cancel(sender:UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        let codexName = codexNameTextField.text
        let modelName = modelNameTextField.text
        let modelOptions = modelOptionsTextField.text
        let modelNickname = modelNicknameTextField.text
        
        // if image is not blank save it
        if (modelImage.image != nil){
            //print("Image is not nil")
            //create an instance of the FileManager
            let fileManager = FileManager.default
            // set image name
            let imageName = codexName! + modelName! + modelOptions!
            print(imageName)
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
        
        
        
        
        if (codexName != nil), (modelName != nil) {
            // Notiy Delegate
            //print("Pre-Delegate message")
            delegate?.controller(controller: self, didSaveModelWithCodex: codexName!, andModelName: modelName!, andModelOptions: modelOptions!, andModelNickname: modelNickname!, andModelImageAddress: modelImageAddress)
            
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
}
