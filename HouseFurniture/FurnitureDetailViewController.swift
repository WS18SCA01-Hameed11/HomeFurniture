
import UIKit

class FurnitureDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var furniture: Furniture?
    
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var furnitureTitleLabel: UILabel!
    @IBOutlet weak var furnitureDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            choosePhotoButton.setTitle("", for: .normal)
            choosePhotoButton.setImage(image, for: .normal)
        } else {
            choosePhotoButton.setTitle("Choose Photo", for: .normal)
            choosePhotoButton.setImage(nil, for: .normal)
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert: UIAlertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            let cameraAction: UIAlertAction = UIAlertAction(
                title: "Camera",
                style: .default) { (action: UIAlertAction) in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let photoLibraryAction: UIAlertAction = UIAlertAction(
                title: "Photo Library",
                style: .default) { (action: UIAlertAction) in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(photoLibraryAction)
        }
        
        let canceAction: UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: .cancel,
                                                       handler: nil)
        alert.addAction(canceAction)
        
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true, completion: nil)
        
    }

    @IBAction func actionButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let furniture: Furniture = furniture else {
            return
        }
        
        let activityController: UIActivityViewController = UIActivityViewController(activityItems: [furniture.description, furniture.imageData as Any], applicationActivities: nil)
        
        //activityController.popoverPresentationController?.sourceView = sender
        
        present(activityController, animated: true)
        
    }
    
    //retrieve the image the user has selected, and dismiss the image picker “if the user decides against picking an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //to retrieve the image from the info dictionary, unwrap and cast it as a UIImage.
        guard let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("could not get original image")
        }
        
        //change UIImagePNGRepresentation() to pngData()
        guard let data: Data = image.pngData() else {
            fatalError("UIImagePNGRepresentation() returned nil")
        }
        
        guard furniture != nil else {
            fatalError("furniture = nil")
        }
        
        //set imageData property on furniture to data(representation the image that has been converted to Data)
        furniture?.imageData = data
        
        dismiss(animated: true, completion: {
            self.updateView()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}
