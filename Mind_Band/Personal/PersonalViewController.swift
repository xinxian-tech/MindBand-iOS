//
//  PersonalViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/5.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
    @IBOutlet weak var melodyTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var melodies: [GeneratedMelody] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        melodyTableView.tableFooterView = UIView(frame: CGRect.zero)
        // melodyTableView.contentInset = UIEdgeInsets(top: -44,left: 0,bottom: 0,right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        melodies = MBDataManager.defaultManager.getAllMelodies()
        melodyTableView.reloadData()
    }

}


extension PersonalViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return melodies.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = melodyTableView.dequeueReusableCell(withIdentifier: "userDetailTableViewCell")!
            return cell
        } else {
            let cell = melodyTableView.dequeueReusableCell(withIdentifier: "melodyTableViewCell")!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt
        indexPath: IndexPath) {
        if let cell = cell as? MelodyTableViewCell {
            cell.melody = melodies[indexPath.row - 1]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 142
        } else {
            return 112
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
