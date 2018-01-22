//
//  PlaceInfoView.swift
//  Detourist
//
//  Created by Lauren Cardella on 1/18/18.
//  Copyright © 2018 Lauren Cardella. All rights reserved.
//

import UIKit

class PlaceInfoView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        contentView = Bundle.main.loadNibNamed("PlaceInfoView", owner: self, options: nil)![0] as! UIView
        self.addSubview(contentView)
        contentView.frame = self.bounds
    }
}
