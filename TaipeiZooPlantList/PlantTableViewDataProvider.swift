//
//  PlantTableViewDataProvider.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/12.
//

import UIKit

class PlantTableViewDataProvider: NSObject,UITableViewDataSource,UITableViewDelegate{
   
    weak var viewController: PlantsViewController?
    
    private var selectedIndex: Int?
    private var lastYPosition: CGFloat = 0.0
    private var currentDirection: ScrollDirection = .down
    private var sectionHeaderView: SectionHeaderView = SectionHeaderView()
    private var viewModel: PlantsViewModel{
        return self.viewController!.viewModel
    }
    private var headerViewHeight: CGFloat{
        return self.viewController?.headerViewHeight ?? 0.0
    }
    
    init(viewController: PlantsViewController){
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.plantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantTableViewCell", for: indexPath) as! PlantTableViewCell
        let plant = self.viewModel.plantList[indexPath.row]
        cell.handleData(with: plant, indexPath.row,isSelected: self.selectedIndex == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame: CGRect = CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 50.0))
        let view = SectionHeaderView(frame: frame)
        let title: String = "已載入\(self.viewModel.plantList.count / 20) / \(self.viewModel.totalPlantsCount / 20)頁，共\(self.viewModel.totalPlantsCount)種植物"
        view.titleLabel.text = title
        view.titleLabel.alpha = 0.0
        self.sectionHeaderView = view
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer{
            if self.selectedIndex != nil{
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        
        guard let previousIndex = self.selectedIndex else{
            self.selectedIndex = indexPath.row
            tableView.reloadRows(at: [indexPath], with: .automatic)
            return
        }
        
        var reloadIndexPath: [IndexPath] = []
        
        if previousIndex == indexPath.row{
            self.selectedIndex = nil
        }else{
            let previousIndexPath = IndexPath(row: previousIndex, section: 0)
            reloadIndexPath.append(previousIndexPath)
            self.selectedIndex = indexPath.row
        }
        
        reloadIndexPath.append(indexPath)
        tableView.reloadRows(at: reloadIndexPath, with: .automatic)
    }
}

extension PlantTableViewDataProvider{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.handleHeaderViewEffect(scrollView)
        self.handleLoadMorePlants(scrollView)
        self.currentDirection = self.lastYPosition > scrollView.contentOffset.y ? .up : .down
        self.lastYPosition = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.handleHeaderViewExpandAnimation(scrollView)
    }
    
    func handleHeaderViewExpandAnimation(_ scrollView: UIScrollView){
        guard scrollView.contentOffset.y < self.headerViewHeight && scrollView.contentOffset.y > 0  else{
            return
        }
        
        let y: CGFloat = self.currentDirection == .up ? 0 : self.headerViewHeight
        let point: CGPoint = CGPoint(x: 0, y: y)
        scrollView.setContentOffset(point, animated: true)
    }
    
    func handleHeaderViewEffect(_ scrollView: UIScrollView){
        let ratio: CGFloat = scrollView.contentOffset.y / self.headerViewHeight
        self.viewController?.headerView.alpha = 1 - ratio
        self.sectionHeaderView.titleLabel.alpha = ratio
    }
    
    func handleLoadMorePlants(_ scrollView: UIScrollView){
        if scrollView.contentOffset.y + 10 < (scrollView.contentSize.height - scrollView.frame.size.height) {
            return
        }

        guard !self.viewModel.isLoading else {
            return
        }
        
        self.viewModel.requestPlantsInfo()
    }
}

enum ScrollDirection{
    case up
    case down
}
