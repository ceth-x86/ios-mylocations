//
//  LocationDetailsViewController.swift
//  My Locations
//
//  Created by demas on 23/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Dispatch

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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var descriptionText = ""
    var categoryName = "No Category"
    var image: UIImage?
    
    var managedObjectContext: NSManagedObjectContext!
    var date = NSDate()
    
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(
                    location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if locationToEdit != nil {
            title = "Edit Location"
            if locationToEdit?.hasPhoto ?? false {
                if let image = locationToEdit?.photoImage {
                    showImage(image: image)
                }
            }
        } 
        
        descriptionTextView.text = ""
        categoryLabel.text = ""
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark: placemark)
        } else {
            addressLabel.text = "No address found"
        }
        
        dateLabel.text = formatDate(date: date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 88
            
        case (1, _):
            return imageView.isHidden ? 44 : 280
            
        case (2, 2):
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 115, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 15
            return addressLabel.frame.size.height + 20
            
        default:
            return 44
        }
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
        
        let hudView = HudView.hudInView(view: navigationController!.view, animated: true)
        var location: Location
        
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: managedObjectContext) as! Location
            location.photoID = nil
        }
        
        location.locationDescription = descriptionText
        location.category = categoryName
        location.longitude = coordinate.longitude
        location.latitude = coordinate.latitude
        location.date = date
        location.placemark = placemark
        
        // Save image
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                self.navigationController?.popViewController(
                    animated: true)
            }
        } catch {
            // fatalCoreDataError(error)
        }
        
       
        afterDelay(0.6, run: { self.dismiss(animated: true, completion: nil)})
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
        
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectCategoryName
        categoryLabel.text = categoryName
    }
    
    // TextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        descriptionText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        descriptionText = textView.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectCategoryName = categoryName
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
    
    func showImage(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
        addPhotoLabel.isHidden = true
    }
    
    
}

extension LocationDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func takePhotoWithCamera() {
        
        let imagePicker = UIImagePickerController();
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        image = info[.editedImage] as? UIImage
        if let theImage = image {
            showImage(image: theImage)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func pickPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: {_ in self.takePhotoWithCamera()})
        alertController.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .default, handler: {_ in self.choosePhotoFromLibrary()})
        alertController.addAction(chooseFromLibraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
}
