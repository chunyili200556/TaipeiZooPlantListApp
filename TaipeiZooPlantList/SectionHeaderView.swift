//
//  SectionHeaderView.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/12.
//

import UIKit

class SectionHeaderView: UIView{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)
        addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.buildEffectView()
    }
    
    func buildEffectView(){
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        effectView.frame = self.bounds
        self.addSubview(effectView)
        self.bringSubviewToFront(self.contentView)
    }
}

