//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Joao Anjos on 19/01/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UINavigationControllerDelegate {

    
    // MARK: - Properties
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAttributes(textField: topTextField)
        self.setupAttributes(textField: bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        
        actionButton.isEnabled = memeImageView.image != nil ? true : false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    // MARK: - Actions
    @IBAction func actionButton_Clicked(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.save(memedImage: memedImage)
            }
        }

    }

    @IBAction func cancelButton_Clicked(_ sender: Any) {
        memeImageView.image = nil
        actionButton.isEnabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        view.endEditing(true)
    }

    @IBAction func cameraButton_Clicked(_ sender: Any) {
        pick(withSource: .camera)
    }
    
    @IBAction func albumButton_Clicked(_ sender: Any) {
       pick(withSource: .photoLibrary)
    }
    @IBAction func closeButton_Clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerController
    
    func pick(withSource source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Keyboard
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if self.bottomTextField.isFirstResponder {
           
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            
            let heightKeyboard =  keyboardSize.cgRectValue.height
            
            self.view.frame.origin.y = heightKeyboard * (-1)
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Helpers
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
        dismiss(animated: true, completion: nil)
    
    }
    
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    
    func setupAttributes(textField field: UITextField) {
        let memeTextAttributes: [String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4
        ]
        field.defaultTextAttributes = memeTextAttributes
        field.textAlignment = .center
        field.autocapitalizationType = .allCharacters
    }

}

extension MemeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.delegate = self
        picker.allowsEditing = true
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
        cancelButton.isEnabled = true
    }
}

extension MemeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" || textField.text == nil {
            if textField == bottomTextField {
                textField.text = "BOTTOM"
            } else {
                textField.text = "TOP"
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}
