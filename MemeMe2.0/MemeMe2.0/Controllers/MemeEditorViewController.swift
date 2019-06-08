//
//  ViewController.swift
//  MemeApp2.0
//
//  Created by Owais Gaffas on 15/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//


import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: OUTLET
    
    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Defualt Text Attributes

    // MARK: DidLoad and WillAppear && DidDisappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFiled(textFiled: topText, text: "Top".uppercased())
        setupTextFiled(textFiled: bottomText, text: "Bottom".uppercased())
        shareButton.isEnabled = false
        
    }
            // default TextFiled
        func setupTextFiled(textFiled: UITextField, text: String){
            textFiled.defaultTextAttributes = [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white ,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSAttributedString.Key.strokeWidth:  -4.0,
            ]
            textFiled.textAlignment = .center
            textFiled.text = text
            textFiled.delegate = self
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(bottomText.isFocused){
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    // MARK: ACTION
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    // Pick from Album
    @IBAction func pickImageAlbum(_ sender: Any) {
     chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    // Pick from Camera
    @IBAction func pickImageCamera(_ sender: Any) {
    chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType.camera)
    }
    
    // Share
    @IBAction func shareImage(_ sender: Any) {
        let sharedImage = generateMemedImage()
        let viewController = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
        present(viewController, animated: true, completion: nil)
        viewController.completionWithItemsHandler = {
            activity, secces, itmes, erorr in
            if secces {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Cancel
    @IBAction func cancelButton(_ sender: Any) {
        resetUI()
        dismiss(animated: true, completion: nil)
    }
    
    // resetButtons when press Cancel
    func resetUI(){
        bottomText.text = "BOTTOM"
        topText.text = "TOP"
        imagePickView.image = nil
        shareButton.isEnabled = false
    }
    
    // did finish!
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.imagePickView.image = image
            self.shareButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: KEYBORAD
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // only up the view when select bottom text
        if (bottomText.isEditing){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // save!
    func save() {
        // Create the meme
        let meme = Meme(top: topText.text!, bottom: bottomText.text!, image: imagePickView.image!, memedImage: generateMemedImage())
        (UIApplication.shared.delegate as! AppDelegate).meme.append(meme)
    }
    
    func ShowAndHideNavAndToolBar(check: Bool){
        navigationBar.isHidden = check
        toolBar.isHidden = check
    }
    
    func generateMemedImage() -> UIImage {
        
       ShowAndHideNavAndToolBar(check: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
     
        ShowAndHideNavAndToolBar(check: false)
        
        return memedImage
        
    }

}


