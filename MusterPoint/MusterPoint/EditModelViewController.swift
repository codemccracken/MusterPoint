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

    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(delegate)
        
        title = "Edit"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        // Populate Text Fields
        codexNameTextField.text = model.codexName
        modelNameTextField.text = model.modelName
        modelOption1TextField.text = model.modelOption1
        modelOption2TextField.text = model.modelOption2
        modelOption3TextField.text = model.modelOption3
        modelOption4TextField.text = model.modelOption4
        modelNicknameTextField.text = model.modelNickname
        
        let fileManager = FileManager.default
        let imageName = model.codexName + model.modelName + model.modelOption1
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            modelImage.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("No Image found")
        }
        modelImage.isUserInteractionEnabled = true
        modelImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
        modelImage.layer.borderWidth = 2
        modelImage.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
    }
    
    @IBOutlet var codexNameTextField: UITextField!
    @IBOutlet var modelNameTextField: UITextField!
    @IBOutlet var modelOption1TextField: UITextField!
    @IBOutlet var modelOption2TextField: UITextField!
    @IBOutlet var modelOption3TextField: UITextField!
    @IBOutlet var modelOption4TextField: UITextField!
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: Actions
    @objc func save(sender: UIBarButtonItem) {
        if let codexName = codexNameTextField.text, let modelName = modelNameTextField.text, let modelOption1 = modelOption1TextField.text, let modelOption2 = modelOption2TextField.text, let modelOption3 = modelOption3TextField.text, let modelOption4 = modelOption4TextField.text, let modelNickname = modelNicknameTextField.text {
            
            // Update model
            model.codexName = codexName
            model.modelName = modelName
            model.modelOption1 = modelOption1
            model.modelOption2 = modelOption2
            model.modelOption3 = modelOption3
            model.modelOption4 = modelOption4
            model.modelNickname = modelNickname
            
            // if image is not blank save it
            if (modelImage != nil){
                //print("Image is not nil")
                //create an instance of the FileManager
                let fileManager = FileManager.default
                // set image name
                
                let imageName = model.codexName + model.modelName + model.modelOption1
                //print(imageName)
                //get the image path
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                //get the image we took with camera
                let image = modelImage.image
                //get the PNG data for this image
                let data = image?.jpegData(compressionQuality: 1.0)
                //store it in the document directory
                fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
                //let modelImageAddress = imagePath
                
            } else {
                //let modelImageAddress = ""
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
    // MARK: -
    // MARK: Expand Image if tapped
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        //print("The image was tapped")
        let imageView = gesture.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    // MARK: Animated Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        
        // check to see if a keyboard exists
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("Show")
            
            // Check to see if the information for the size of the keyboard exists
            guard let userInfo = notification.userInfo
                else {return}
            
            // get the size of the keyboard
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                else {return}
            
            // get the duration of the keyboard transition
            let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
            
            // get the type and speed of the keyboard transition
            let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
            
            // move the frame by the size of the keyboard
            let keyboardFrame = keyboardSize.cgRectValue
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardFrame.height
                }
            }, completion: nil)
            
            
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("Hide")
            
            // Check to see if the information for the size of the keyboard exists
            guard let userInfo = notification.userInfo
                else {
                    return
                    
            }
            
            // get the size of the keyboard
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                else {
                    return
                    
            }
            
            // move the frame by the size of the keyboard
            let keyboardFrame = keyboardSize.cgRectValue
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardFrame.height
            }
            
        }
    }
}
