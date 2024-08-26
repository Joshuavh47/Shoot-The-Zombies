//
//  HighScoreTableViewController.swift
//  Shoot The Zombies
//
//  Created by Joshua Eres on 4/12/24.
//
// Josh Eres - jeeres
// Jalen Moya - jamoya
// Submitted: 4/25/24

import UIKit

class HighScoreTableViewController: UITableViewController {

    let model = GameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        print("test")
        print(model.highScores)
        fetchHighScores()
        
        let backButton = UIBarButtonItem(title: "Back to Menu", style: .plain, target: self, action: #selector(backToMenu))
            navigationItem.leftBarButtonItem = backButton
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHighScores() // Fetch high scores again when the view will appear
    }

    func fetchHighScores() {
        model.highScores = DataModelManager.shared.fetchHighScores()
        tableView.reloadData()
    }
    
    @objc func backToMenu() {
        // Perform navigation back to the main menu
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return "High Scores"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.highScores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if(indexPath.row == 0 && model.highScores.count > 0){
            var highest:Int64 = 0
            var obj:HighScore?
            for s in model.highScores{
                if s.score>highest{
                    highest = s.score
                    obj = s
                }
            }
            cell.textLabel?.text = "High Score - \(obj?.playerName ?? "Player"): \(obj?.score ?? 0)"
            return cell
        }
            
        let highScore = model.highScores[indexPath.row]
        cell.textLabel?.text = "\(highScore.playerName ?? "PLayer") - Score: \(highScore.score)"
            
        return cell
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
