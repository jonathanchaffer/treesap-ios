//
//  AddTreePhotoViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/4/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Adapted from https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/
//

import UIKit

class AddTreePhotoViewController: AddTreeViewController {
    
    let pickerController = UIImagePickerController()
    let delegate = self
    var selectedImage: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
    }
    
    /// Function that is called when the Take/Choose Photo button is pressed.
    func takeOrChoosePhoto() {
        presentAlertController()
    }
    
    /// Presents an alert controller containing options for camera and photo library.
    private func presentAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Choose photo") {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
    
    /**
     Creates an alert controller action for the given source type and title.
     - Parameter type: The source type for the action.
     - Parameter title: The title for the action.
     - Returns: A UIAlertAction for the given source type and title.
     */
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.present(self.pickerController, animated: true)
        }
    }
    
    /// Function that is called when an image has been selected.
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.selectedImage = image
        self.updateImage()
    }
    
    /// Updates the UIImageView on the current page.
    func updateImage() { }
}

extension AddTreePhotoViewController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension AddTreePhotoViewController: UINavigationControllerDelegate {
    
}
