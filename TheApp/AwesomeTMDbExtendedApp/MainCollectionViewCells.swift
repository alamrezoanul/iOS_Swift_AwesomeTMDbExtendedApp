//
//  MainCollectionViewCells.swift
//  awesometmdbextendedapp
//
//  Created by TAHIYAH ALAM KHAN on 4/14/17.
//  Copyright © 2017 Rezoanul Alam Riad. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var release_date: UILabel!
}

class MainHeader: UICollectionReusableView{
    @IBOutlet var genreName: UILabel!
}
