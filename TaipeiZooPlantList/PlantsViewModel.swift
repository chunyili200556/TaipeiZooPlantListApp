//
//  PlantViewModel.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/12.
//

import Foundation
import Combine

class PlantsViewModel{
    @Published var plantList: [Plant] = []
    var page: Int = 1
    var totalPlantsCount: Int = 0
    var isLoading: Bool = false
    
    func requestPlantsInfo(){
        self.isLoading = true
        let offset: Int = (page - 1) * 20
        let param = ["scope": "resourceAquire",
                     "rid": "f18de02f-b6c9-47c0-8cda-50efad621c14",
                     "limit": "20",
                     "offset": "\(offset)"]
        let urlStr: String = "https://data.taipei/opendata/datalist/apiAccess"
        WebService.request(urlStr: urlStr, param: param) { dictionary in
            guard let dictionary = dictionary,
                  let result = dictionary["result"] as? NSDictionary,
                  let count: Int = result["count"] as? Int,
                  let plantsDic = result["results"] as? [NSDictionary] else{
                return
            }
            
            self.totalPlantsCount = count
            
            let plants: [Plant] = plantsDic.map { dic in
                guard let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted),
                      let plant = try? JSONDecoder().decode(Plant.self, from: data) else{
                    fatalError()
                }
                return plant
            }
            
            guard plants.count > 0 else{
                return
            }
            
            self.plantList += plants
            self.page += 1
            self.isLoading = false
        }
    }
}
