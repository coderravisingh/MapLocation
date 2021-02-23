//
//  SearchViewController.swift
//  MapLocation
//
//  Created by RaviSingh on 25/01/21.
//

import UIKit
import CoreLocation

protocol searchViewControllerDelegate: AnyObject {
    func searchViewController(_vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?)
    
    
}


class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource {
   
    weak var delegate: searchViewControllerDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Where To?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        
        return label
    }()
    
    private let textField : UITextField = {
        let textField =  UITextField()
        textField.placeholder = "Search"
        textField.layer.cornerRadius = 9
        textField.backgroundColor = .tertiarySystemBackground
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let tableView: UITableView = {
       
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.backgroundColor = .secondarySystemBackground
        return table
        
    }()
    
    var location = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        textField.delegate = self
    

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 10, width: label.frame.size.width, height: label.frame.size.height)
        textField.frame = CGRect(x: 10, y: 20+label.frame.size.height, width: view.frame.size.width - 20, height: 50)
        let tableY:CGFloat = textField.frame.origin.y+textField.frame.size.height+5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height - tableY)
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            LocationManager.shared.findLocation(with: text) { [weak self]locations in
                DispatchQueue.main.async {
                    self?.location = locations
                    self?.tableView.reloadData()
                }
            }
        }
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = location[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let coordinates = location[indexPath.row].coordinate
        delegate?.searchViewController(_vc: self, didSelectLocationWith: coordinates)
    }
}
