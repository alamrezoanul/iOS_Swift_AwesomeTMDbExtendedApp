//
//  DetailViewController.swift
//  AwesomeTMDbExtendedApp
//
//  Created by TAHIYAH ALAM KHAN on 4/16/17.
//  Copyright © 2017 Rezoanul Alam Riad. All rights reserved.
//

import Foundation
import TMDBSwift

class DetailViewController: UIViewController {
    var movieId : String?
    var movieTitle : String?
    var movieDict : NSDictionary?
    var activityIndicatorView : UIActivityIndicatorView?
    
    @IBOutlet weak var movieCoverImageView : UIImageView?
    @IBOutlet weak var movieDescriptionTextView : UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = self.movieTitle
        if( self.movieDict?["image_url"] != nil ){
            let urlString = self.movieDict?["image_url"] as! String
            self.movieCoverImageView?.af_setImage(withURL: URL(string:urlString)!)
        }
        else{
            self.movieCoverImageView?.image = UIImage(named: "placeholder")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.movieDescriptionTextView?.text = String(describing: self.movieDict?["overview"])
        self.movieDescriptionTextView?.font = UIFont.systemFont(ofSize: 17)
        self.movieDescriptionTextView?.textColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
}
