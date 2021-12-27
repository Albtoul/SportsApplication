//
//  SportsViewController.swift
//  SportsApplication
//
//  Created by Hell on 27/12/2021.
//

import UIKit
import CoreData

class SportsViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    let imageVC = UIImagePickerController()
    
    var sports : [Sport] = []
    var selectedSport : Sport!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSports()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sports.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportCell
        
        let sport = sports[indexPath.row]
        cell.delegate = self
        cell.configureCell(text: sport.name, imageData: sport.image)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerVC = storyboard?.instantiateViewController(identifier: "PlayerVC") as! PlayersViewController
        playerVC.sport = sports[indexPath.row]
        navigationController?.pushViewController(playerVC, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let sport = sports[indexPath.row]
        context.delete(sport)
        saveContext()
        fetchSports()
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        sportAlert(title: "Edit Sport", message: "Enter New Sport Name", inputPlaceHolder: nil, inputText: sports[indexPath.row].name, sport: sports[indexPath.row])
    }
    
    // Add Button Function
    
    @IBAction func addBarButtonPressed() {
        sportAlert(title: "Add Sport", message: "Enter Sport Name", inputPlaceHolder: "BasketBall", inputText: nil, sport:nil)
    }
    
    
    
    // My Functions
    
    func fetchSports(){
        do{
            sports = try context.fetch(Sport.fetchRequest())
        }catch{
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    func sportAlert(title:String,message:String,inputPlaceHolder:String?,inputText:String?, sport:Sport?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {
            textField in
            textField.text = inputText
            textField.placeholder = inputPlaceHolder
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            _ in
            let sportName = alert.textFields![0].text
            if let sport = sport {
                sport.name = sportName
            }else{
                let sport = Sport(context: self.context)
                sport.name = sportName
            }
            self.saveContext()
            self.fetchSports()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            _ in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension SportsViewController : SportDelegate {
    func addImage(_ cell: SportCell) {
        let selectedIndex = tableView.indexPath(for: cell)?.row ?? 0
        selectedSport = sports[selectedIndex]
        imageVC.sourceType = .photoLibrary
        imageVC.delegate = self
        present(imageVC, animated: true, completion: nil)
    }
}

extension SportsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.pngData() {
                selectedSport.image = imageData
                saveContext()
            }
        }
        
        tableView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
