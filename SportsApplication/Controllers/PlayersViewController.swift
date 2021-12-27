//
//  PlayersViewController.swift
//  SportsApplication
//
//  Created by Hell on 27/12/2021.
//

import UIKit
import CoreData

class PlayersViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    var sport:Sport!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = sport.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonPressed))
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sport.players?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        
        if let player = sport.players?[indexPath.row] as? Player{
            
            cell.textLabel?.text = "\(player.name ?? "") - \(player.age ?? "") - \(player.height ?? "")"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let player = sport.players?[indexPath.row] as! Player
        
        sport.removeFromPlayers(player)
        saveContext()
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let player = sport.players?[indexPath.row] as! Player
        playerAlert(title: "Edit Player", message: "Enter New Player Details", player: player)
    }
    
    // Add Player Function
    @objc func addBarButtonPressed(){
        playerAlert(title: "Add Player", message: "Enter Player Details", player: nil)
    }
    
    // My Functions
    
    func playerAlert(title:String,message:String, player:Player?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {
            textField in
            textField.text = player?.name
            textField.placeholder = "Player Name"
        })
        
        alert.addTextField(configurationHandler: {
            textField in
            textField.text = player?.age
            textField.placeholder = "Player Age"
        })
        
        alert.addTextField(configurationHandler: {
            textField in
            textField.text = player?.height
            textField.placeholder = "Player Height"
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            _ in
            
            let playerName = alert.textFields![0].text
            let playerAge = alert.textFields![1].text
            let playerHeight = alert.textFields![2].text
            
            if let player = player {
                player.name = playerName
                player.age = playerAge
                player.height = playerHeight
                player.sport = self.sport
            }
            else{
                let player = Player(context: self.context)
                player.name = playerName
                player.age = playerAge
                player.height = playerHeight
                player.sport = self.sport
            }
            
            
            self.saveContext()
            self.tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            _ in
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
