//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Григорий Душин on 06.09.2022.
//

import UIKit
import Cosmos

class NewPlaceViewController: UITableViewController, UINavigationControllerDelegate {

    
    var currentPlace: Place!
    var imageIsChanged = false
    var currentRating = 0.0
    
    

    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false        
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditscreen()
        
        cosmosView.didTouchCosmos = { rating in self.currentRating = rating }
    }
    //MARK: TableView Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)

            }
            camera.setValue(cameraIcon, forKey: "image")
           
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
          
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
  
    
    func savePlace() {
 
        let image = imageIsChanged ? placeImage.image : UIImage(named: "imagePlaceholder")
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!, location: placeLocation.text, type: placeType.text, imageData: imageData, rating: currentRating)
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            } } else {
                StorageManager.saveObject(newPlace)
            
        }
       
       
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier,
            let mapVC = segue.destination as? MapViewController
            else { return }
        
        mapVC.incomeSegueIdentifire = identifier
        mapVC.mapViewControllerDelegate = self
        
        if identifier == "showPlace" {
            mapVC.place.name = placeName.text!
            mapVC.place.location = placeLocation.text
            mapVC.place.type = placeType.text
            mapVC.place.imageData = placeImage.image?.pngData()
        }
    }
    
    
    
    
    private func setupEditscreen() {
        setupNavigationBar()
        imageIsChanged = true
        if currentPlace != nil {
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
            placeImage.image = image
            placeType.text = currentPlace?.type
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            cosmosView.rating = currentPlace.rating
            
           
        }
    }
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}


//MARK: TextField Delegate

extension NewPlaceViewController: UITextFieldDelegate {
    
    //скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //скрываем клавиатуру по нажатию на ячейку
    
    @objc private func textFieldChanged(){
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true } else {
                saveButton.isEnabled = false
        }
    }
    
    
}

//MARK: Work with image

extension NewPlaceViewController : UIImagePickerControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
extension NewPlaceViewController: MapViewControllerDelegate {
    func getAdress(_ adress: String?) {
        placeLocation.text = adress
    }
    
    
}
