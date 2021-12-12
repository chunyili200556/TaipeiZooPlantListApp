//
//  ViewController.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/10.
//

import UIKit
import Combine

class PlantsViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: PlantsViewModel = PlantsViewModel()
    var dataProvider: PlantTableViewDataProvider?
    private var cancellables = Set<AnyCancellable>()
    
    var headerViewHeight: CGFloat{
        return self.headerView.frame.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.viewModel.requestPlantsInfo()
        self.handleViewModelPublished()
    }
    
    private
    func setupTableView(){
        self.dataProvider = PlantTableViewDataProvider(viewController: self)
        self.tableView.delegate = self.dataProvider
        self.tableView.dataSource = self.dataProvider
        self.tableView.register(UINib(nibName: "PlantTableViewCell", bundle: nil), forCellReuseIdentifier: "PlantTableViewCell")
    }
    
    func handleViewModelPublished(){
        self.viewModel.$plantList
            .receive(on: DispatchQueue.main)
            .sink { planList in
            guard planList.count > 0 else{
                return
            }
            self.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
}
