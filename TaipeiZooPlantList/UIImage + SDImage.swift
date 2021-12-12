//
//  UIImage + SDImage.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/12.
//

import UIKit
import SDWebImage

extension UIImageView{
    func setupImage(urlStr : String){
        guard var component = URLComponents(string: urlStr) else{
            return
        }
        component.scheme = "https"
        
        self.sd_setImage(with: component.url)
    }
}
