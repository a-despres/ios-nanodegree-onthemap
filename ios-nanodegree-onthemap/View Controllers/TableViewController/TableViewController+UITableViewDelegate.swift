//
//  TableViewController+UITableViewDelegate.swift
//  ios-nanodegree-onthemap
//
//  Created by Andrew Despres on 12/24/18.
//  Copyright © 2018 Andrew Despres. All rights reserved.
//

import UIKit

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentLocations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        // change background color of selected cell
        let customSelectedBackground: UIView = UIView()
        customSelectedBackground.backgroundColor = UIColor(red: 1, green: 99/255, blue: 72/255, alpha: 1)
        cell.selectedBackgroundView = customSelectedBackground
        
        // display student location in cell
        if let studentLocations = appDelegate.studentLocations {
            let studentName = "\(studentLocations[indexPath.row].firstName) \(studentLocations[indexPath.row].lastName)"
            cell.nameLabel.text = studentName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let studentLocations = appDelegate.studentLocations {
            guard let url = URL(string: studentLocations[indexPath.row].mediaURL) else { return }
            UIApplication.shared.open(url, options: [:]) { [unowned self] success in
                if !success {
                    self.present(ErrorAlert.Alert.url.alertController, animated: true, completion: nil)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
