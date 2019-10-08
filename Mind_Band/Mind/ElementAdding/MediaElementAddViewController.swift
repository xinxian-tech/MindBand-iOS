//
//  MediaElementAddViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 7/17/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit

protocol MediaElementAddDelegate {
    func mediaElementSelected(element: MediaElement)
}

class MediaElementAddViewController: UIViewController {

    var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var delegate: MediaElementAddDelegate?
    var mediaElement: MediaElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add an Image"
        confirmButton.isEnabled = false
        
//        navigationItem.leftBarButtonItem = cancelButton
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.addSubview(confirmButton)
        view.addSubview(cancelButton)
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            confirmButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1),
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalTo: confirmButton.heightAnchor, multiplier: 1)
        ])
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16)
        ])
    }

   @objc func confirmButtonTapped(_ sender: UIButton) {
        delegate?.mediaElementSelected(element: mediaElement!)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
//    @objc func cancelButtonTapped(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    
    func setConfirmButtonEnabled() {
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    }
}
