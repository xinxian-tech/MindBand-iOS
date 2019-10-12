//
//  ImageElementAddViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 7/17/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit
import Photos
import CoreServices

class ImageElementAddViewController: MediaElementAddViewController {
    
    var chooseImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose an image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 4.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(chooseImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var imagePreviewView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dataManager = MBDataManager.defaultManager

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMediaElement()
        
        contentView.addSubview(chooseImageButton)
        contentView.addSubview(imagePreviewView)
        NSLayoutConstraint.activate([
            chooseImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            chooseImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            chooseImageButton.widthAnchor.constraint(equalToConstant: 200),
            chooseImageButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        NSLayoutConstraint.activate([
            imagePreviewView.bottomAnchor.constraint(equalTo: chooseImageButton.topAnchor, constant: -16),
            imagePreviewView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imagePreviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imagePreviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
    
    private func loadMediaElement() {
        if mediaElement == nil {
            mediaElement = ImageElement()
        } else {
            imagePreviewView.image = UIImage(data: try! Data(contentsOf: (mediaElement as! ImageElement).imageContentURL!))
            setConfirmButtonEnabled()
        }
    }
    
    @objc private func chooseImageButtonTapped() {
        let imagePickerControler = UIImagePickerController()
        imagePickerControler.delegate = self
        imagePickerControler.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]
        present(imagePickerControler, animated: true, completion: nil)
    }
}

extension ImageElementAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imagePreviewView.image = selectedImage
        dataManager.saveTemporaryData(data: selectedImage!.jpegData(compressionQuality: 1)!, postfix: "jpeg") { url in
            self.mediaElement?.prepareContent(content: url)
            if let livePhoto = info[UIImagePickerController.InfoKey.livePhoto] as? PHLivePhoto {
                let assetResources = PHAssetResource.assetResources(for: livePhoto)
                for resource in assetResources {
                    if resource.type == .pairedVideo {
                        PHAssetResourceManager.default().writeData(for: resource, toFile: url.deletingPathExtension().appendingPathExtension("mov"), options: nil) { error in
                        }
                    }
                }
            }
            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = #colorLiteral(red: 1, green: 0.2608970106, blue: 0.4899148345, alpha: 1)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
