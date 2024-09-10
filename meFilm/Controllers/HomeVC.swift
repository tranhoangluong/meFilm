//
//  HomeVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 7/9/24.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView(){
        let reuseTableViewCell = UINib(nibName: "ReuseTableViewCell", bundle: nil)
        tableView.register(reuseTableViewCell, forCellReuseIdentifier: "reuseTableViewCell")
        let reuseTableCollectionViewCell = UINib(nibName: "ReuseTableCollectionViewCell", bundle: nil)
        tableView.register(reuseTableCollectionViewCell, forCellReuseIdentifier: "reuseTableCollectionViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseTableViewCell") as! ReuseTableViewCell
            return cell
        } else {
            let colCell = tableView.dequeueReusableCell(withIdentifier: "reuseTableCollectionViewCell") as! ReuseTableCollectionViewCell
            return colCell
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
}
