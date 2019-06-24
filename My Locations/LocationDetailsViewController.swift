//
//  LocationDetailsViewController.swift
//  My Locations
//
//  Created by demas on 23/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit
import CoreLocation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()



class LocationDetailsViewController : UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var descriptionText = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        descriptionTextView.text = ""
        categoryLabel.text = ""
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        descriptionTextView.text = descriptionText
        
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark: placemark)
        } else {
            addressLabel.text = "No address found"
        }
        
        dateLabel.text = formatDate(date: NSDate())
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        }
        
        if indexPath.section == 2 && indexPath.row == 2 {
            
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
            return addressLabel.frame.size.height + 20
        }
        
        return 44
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        
        return
            "\(placemark.subThoroughfare ?? "") \(placemark.thoroughfare ?? "")\n" +
                "\(placemark.locality ?? "") \(placemark.administrativeArea ?? "") " +
        "\(placemark.postalCode ?? "")"
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.string(from: date as Date)
    }
    
    @IBAction func done() {
        print("Description \(descriptionText)")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // TextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        descriptionText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        descriptionText = textView.text
    }
}
