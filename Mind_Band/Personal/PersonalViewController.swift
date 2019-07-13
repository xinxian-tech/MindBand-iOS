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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        melodies = MBDataManager.defaultManager.getAllMelodies()
        melodyTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showMelodyDetail" {
            let destination = segue.destination as! MelodyDetailViewController
            destination.melody = sender as? GeneratedMelody
        }
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
        if indexPath.row != 0 {
            performSegue(withIdentifier: "showMelodyDetail", sender: melodies[indexPath.row - 1])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt
        indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt
        indexPath: IndexPath) {
        MBDataManager.defaultManager.removeMelody(id: melodies[indexPath.row - 1].id!)
        melodies.remove(at: indexPath.row - 1)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
