//
//  AddTreePhotoViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and modified by Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Used https://theswiftdev.com/2019/01/30/picking-images-with-uiimagepickercontroller-in-swift-5/ as a reference.
//

import ImageSlideshow
import UIKit

class AddTreePhotoViewController: AddTreeViewController {
    let pickerController = UIImagePickerController()
    let delegate = self
    var selectedImages = [UIImage]()

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

    /// Deletes the current image.
    func clearImages() {
        selectedImages = []
        updateImages()
    }

    /// Shows the next button and hides the skip button.
    func showNextButton(nextButton: UIButton, skipButton: UIButton) {
        nextButton.isHidden = false
        skipButton.isHidden = true
    }

    /// Shows the skip button and hides the next button.
    func showSkipButton(nextButton: UIButton, skipButton: UIButton) {
        nextButton.isHidden = true
        skipButton.isHidden = false
    }

    /// Presents an alert controller containing options for camera and photo library.
    private func presentAlertController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let action = self.action(for: .camera, title: StringConstants.addPhotoPromptCameraAction) {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: StringConstants.addPhotoPromptGalleryAction) {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel, handler: nil))
        present(alertController, animated: true)
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
        if image != nil {
            selectedImages.append(image!)
        }
        updateImages()
    }

    func updateImages() {}

    /// Updates the image slideshow on the current page.
    func updateImages(imageSlideshow: ImageSlideshow, nextButton: UIButton, skipButton: UIButton, clearPhotosButton: UIButton, addPhotoButton: UIButton) {
        var imageSources = [ImageSource]()
        for image in selectedImages {
            imageSources.append(ImageSource(image: image))
        }
        if !selectedImages.isEmpty {
            nextButton.isHidden = false
            skipButton.isHidden = true
            clearPhotosButton.isHidden = false
            addPhotoButton.setTitle("Add Another Photo", for: .normal)
        } else {
            imageSources.append(ImageSource(image: UIImage(named: "noPhotoSelected")!))
            nextButton.isHidden = true
            skipButton.isHidden = false
            clearPhotosButton.isHidden = true
            addPhotoButton.setTitle("Take/Choose Photo", for: .normal)
        }
        imageSlideshow.setImageInputs(imageSources)
        imageSlideshow.setCurrentPage(selectedImages.count - 1, animated: false)
    }
}

extension AddTreePhotoViewController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return pickerController(picker, didSelect: nil)
        }
        pickerController(picker, didSelect: image)
    }
}

extension AddTreePhotoViewController: UINavigationControllerDelegate {}
