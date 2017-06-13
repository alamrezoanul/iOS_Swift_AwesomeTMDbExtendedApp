//
//  Test.swift
//  AwesomeTMDbExtendedApp
//
//  Created by TAHIYAH ALAM KHAN on 4/14/17.
//  Copyright © 2017 Rezoanul Alam Riad. All rights reserved.
//

import Foundation
import TMDBSwift
import UIKit

class All: UIViewController {
    
    
    var images: [Images_MDB]?
    var credits: PersonCreditsCombined!
    
    override func viewDidLoad() {
        
        PersonMDB.personAppendTo(apikey, personID: 1245, append_to: ["images", "combined_credits"]){
            data in
            self.images = Images_MDB.initialize(json: data.2!["images"]["profiles"])
            print(self.images?.count ?? 0)
            self.credits = PersonCreditsCombined.init(json: data.2!["combined_credits"])
            print(self.credits.tvCredits.cast?.count ?? 0)
            print(self.credits.movieCredits.cast?.count ?? 0)
        }
        
    }
    
}
