//
//  MemeEditorViewController.swift
//  MemeMe_2.0
//
//  Created by Rana Omar on 04/06/1440 AH.
//  Copyright © 1440 Rana Aljasser. All rights reserved.
//

import UIKit

    class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Outlet Conections
    
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage: UIImage!
        
        // Textfield Characteristics
        
        let memeTextAttributes = [
            
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Impact", size: 45)!,
            NSAttributedString.Key.strokeWidth : NSNumber(value: -3.0 as Float)
        ]
        
        func setTextAttribute(_ textField : UITextField, str : String) {
            textField.text = str
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .center
            textField.backgroundColor = .clear
            textField.borderStyle = .none
            textField.autocapitalizationType = .allCharacters
            
        }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextAttribute(bottomText, str : " BOTTOM ")
        setTextAttribute(topText, str: " TOP ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    // Keyboard Notifications
    
        func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
        func unsubscribeToKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    // Keyboard Will Show/Hide
    
        @objc func keyboardWillShow(_ notification:Notification) {
            if bottomText.isFirstResponder {
                view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            }
        }
    
        @objc func keyboardWillHide(_ notification:Notification) {
            if bottomText.isFirstResponder {
                view.frame.origin.y = 0
            }
        }
    
    // Keyboard Height
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Actions
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        
        if (sender == cameraButton) {
            presentPickerController(sourceType: .camera)
        }
        else {
            presentPickerController(sourceType: .photoLibrary)
        }
    }
    
        func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
        
    }
    
    // Image Picker
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imagePickerView.contentMode = .scaleAspectFit
                imagePickerView.image = pickedImage
            }
            
            dismiss(animated: true, completion: nil)
        }
    
    // Did Cancel
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Generate meme + share + save
    
    func save() {
        //Create the meme
        let meme = MemeObject (topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    // Create a UIImage that combines the Image View and the Labels
    
    func generateMemedImage() -> UIImage {
        
        toolBarVisible(false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBarVisible(true)
        
        return memedImage
    }
    
    @IBAction func shareButton(_ sender: AnyObject) {
        
        let memeToShare = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.safelySaveMeme(memeToShare)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func safelySaveMeme(_ memedImage: UIImage) {
        
        // safely unwrap optionals
        if imagePickerView.image != nil && topText.text != nil && bottomText.text != nil
        {
            let top = self.topText.text!
            let bottom = self.bottomText.text!
            let image = self.imagePickerView.image!
            
            let meme = MemeObject (topText: top, bottomText: bottom, originalImage: image, memedImage: memedImage)
            (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        }
        
    }
    
    //Changing textfields' text when starting to edit
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField == topText && topText.text == " TOP ") {
            topText.text = ""
        } else if (textField == bottomText && bottomText.text == " BOTTOM ") {
            bottomText.text = ""
        }
    }
        
        //Rewriting the captions if there is no editing
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if (textField == topText && topText.text == "") {
                topText.text = "TOP"
            } else if (textField == bottomText && bottomText.text == "") {
                bottomText.text = "BOTTOM"
            }
        }
    
    // Return To Escape
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // Toolbar
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        topText.isHidden = true
        bottomText.isHidden = true
        imagePickerView.isHidden = true
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        dismiss(animated: true, completion: nil)
    }
    
    func toolBarVisible(_ visible: Bool) {
        
        if !visible {
            navBar.isHidden = true
            toolBar.isHidden = true
        } else {
            navBar.isHidden = false
            toolBar.isHidden = false
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}

