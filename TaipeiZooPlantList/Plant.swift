//
//  Model.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/12.
//

import Foundation

struct Plant: Codable{
    let name: String
    let latinName: String
    let location: String
    let feature: String
    let imageStr: String
    
    enum CodingKeys: String, CodingKey{
        case name = "F_Name_Ch"
        case latinName = "F_Name_Latin"
        case location = "F_Location"
        case feature = "F_Feature"
        case imageStr = "F_Pic01_URL"
    }
}
