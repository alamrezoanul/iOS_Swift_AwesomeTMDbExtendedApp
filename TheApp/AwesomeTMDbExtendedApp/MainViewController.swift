//
//  MainViewController.swift
//  AwesomeTMDbExtendedApp
//
//  Created by TAHIYAH ALAM KHAN on 4/14/17.
//  Copyright © 2017 Rezoanul Alam Riad. All rights reserved.
//

import UIKit
import TMDBSwift
import AlamofireImage
import ScrollPager

class MainViewController: UICollectionViewController, ScrollPagerDelegate{
    
    var roundButton = UIButton()
    
    fileprivate let reuseIdentifier = "mainCollectionViewCell"
    
    var isFiltering = false
    var dataSourceFiltered = [MovieMDB]()
    var dataSource = [MovieMDB]()
    var pageResult: PageResultsMDB!
    
    //@IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var pager: ScrollPager!
    
    var moviesPager = ["Popular", "Top Rated", "Now Playing"]
    var page = 1
    var scrollIndex = 0
    override func viewDidLoad() {
        
        pager.delegate = self
        APIFuncs.loadMovieData(0){
            api in
            self.pageResult = api.0.pageResults
            if(api.1 != nil){
                self.dataSource = api.1!
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView?.reloadData()
                })
            }
        }
        pager.addSegmentsWithTitles(segmentTitles: moviesPager)
        
        addFilterButton()
        isFiltering = false
    }
    
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        isFiltering = false
        page = 1
        dataSource.removeAll()
        scrollIndex = changedIndex
        APIFuncs.loadMovieData(changedIndex, page: page){
            api in
            if(api.1 != nil){
                self.dataSource = api.1!
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView?.reloadData()
                    self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                })
            }
        }
    }
}

// MARK: - Privates
extension MainViewController{
    func mediaPath(aMovie : MovieMDB) -> String? {
        var url : String?
        
        var source = aMovie.backdrop_path
        
        if(source != nil){
            url = imageBaseUrl780+(source)!
            
        }else{
            source = aMovie.poster_path ?? nil
            url = source != nil ? imageBaseUrl500+source! : nil
            
        }
        
        return url;
    }
    
    @IBAction func showFilter(_ sender: UIButton){
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: "Please Enter", message: "", preferredStyle: .alert)
        
        actionSheetController.addTextField(configurationHandler: { (textField) -> Void in
            textField.keyboardType = UIKeyboardType.numberPad
            textField.placeholder = "MIN YEAR"
        })
        actionSheetController.addTextField(configurationHandler: { (textField) -> Void in
            textField.keyboardType = UIKeyboardType.numberPad
            textField.placeholder = "MAX YEAR"
        })
        let filterActionButton = UIAlertAction(title: "Filter", style: .default) { _ in
            let textFieldMinYear = actionSheetController.textFields![0] as UITextField
            let textFieldMaxYear = actionSheetController.textFields![1] as UITextField
            
            self.dataSourceFiltered = self.dataSource.filter { (movie: MovieMDB) -> Bool in
                
                let strRelease_date = movie.release_date ?? ""
                let tmps = strRelease_date.components(separatedBy: "-")
                let release_year = tmps.count == 3 ? Int(tmps[0]) : 0
                
                let minYear = (textFieldMinYear.text?.isEmpty)! ? 0 : Int(textFieldMinYear.text!)
                let maxYear = (textFieldMaxYear.text?.isEmpty)! ? 0 : Int(textFieldMaxYear.text!)
                
                return ( release_year! >= minYear! && release_year! <= maxYear! )
            }
            
            if( self.dataSourceFiltered.count > 0 )
            {
                self.isFiltering = true
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView?.reloadData()
                })
            }
            else{
                self.isFiltering = false
            }
            
        }
        actionSheetController.addAction(filterActionButton)
        
        let clearFilterActionButton = UIAlertAction(title: "Clear Filter", style: .default) { _ in
            self.isFiltering = false
            DispatchQueue.main.async(execute: { () -> Void in
                self.collectionView?.reloadData()
            })
        }
        actionSheetController.addAction(clearFilterActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    func addFilterButton() {

        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(showFilter(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(roundButton)

    }

    override func viewWillLayoutSubviews() {
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.lightGray
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"search"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
            roundButton.widthAnchor.constraint(equalToConstant: 50),
            roundButton.heightAnchor.constraint(equalToConstant: 50)])
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController{
    //1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        var _count : Int
        
        if( isFiltering ){
            _count = dataSourceFiltered.count
        }
        else{
            _count = dataSource.count
        }
        
        return _count
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
        
        var aMovie : MovieMDB
        if( isFiltering ){
            aMovie = dataSourceFiltered[indexPath.row]
        }
        else
        {
            aMovie = dataSource[indexPath.row]
        }
        let title = aMovie.original_title
        if( title != nil )
        {
            cell.title.text = title
        }
        else
        {
            cell.title.text = "No title available!"
        }
        let release_date = aMovie.release_date
        if( release_date != nil )
        {
            cell.release_date.text = "Release Date: " + release_date!
        }
        else
        {
            cell.release_date.text = "Release Date Not Found!"
        }
        let imageUrl = mediaPath(aMovie: aMovie)
        if( imageUrl != nil ){
            cell.imageView.af_setImage(withURL: URL(string: imageUrl!)!)
        }
        else{
            cell.imageView.image = UIImage(named: "placeholder")
        }
        
        
        var width = 300
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            width = 550
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            width = 550
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            width = 300
        }
        
        let sizeLabel = CGSize(width: CGFloat(Float(width)), height: cell.title.frame.size.height)
        let sizeImage = CGSize(width: CGFloat(Float(width)), height: cell.imageView.frame.size.height)
        
        cell.title.frame.size = sizeLabel
        cell.release_date.frame.size = sizeLabel
        cell.imageView.frame.size = sizeImage
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if( isFiltering ) { return }
        
        if indexPath.row == dataSource.count - 2{
            if(page < pageResult.total_pages){
                print("loading more")
                page += 1
                print(moviesPager[scrollIndex])
                print(pageResult.page, "current page")
                APIFuncs.loadMovieData(scrollIndex, page: page){
                    api in
                    self.pageResult = api.0.pageResults
                    if(api.1 != nil){
                        for i in api.1!{
                            self.dataSource.append(i)
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.collectionView?.reloadData()
                        })
                    }
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let movieDetailViewController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        {
            
            var aMovie : MovieMDB
            if( isFiltering ){
                aMovie = dataSourceFiltered[indexPath.row]
            }
            else
            {
                aMovie = dataSource[indexPath.row]
            }
            var id = 0
            id = aMovie.id ?? 0
            movieDetailViewController.movieId = String(id)
            movieDetailViewController.movieTitle = aMovie.title
            
            let imageUrl = mediaPath(aMovie: aMovie)
            let movieDictPriv = ["image_url": imageUrl, "overview":aMovie.overview]
            movieDetailViewController.movieDict = movieDictPriv as NSDictionary
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        }
        
    }
    
}

extension MainViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        
        //return CGSize(width: 300, height: 180)
        //let length = (UIScreen.main.bounds.width-15)///2
        //return CGSize(width: length, height: 180)
        let height = 216
        var width = 300
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            width = 550
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            width = 550
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            width = 300
        }
        
        return CGSize(width: width, height: height)
    }
    
}

class APIFuncs{
    
    //this corrsponds to the selected index of the page scroller
    class  func loadMovieData(_ index: Int, page: Int = 1, completionHandler: @escaping (ClientReturn, [MovieMDB]?) -> ()) -> (){
        switch index {
        case 0:
            MovieMDB.popular(apikey, language: "en", page: page){
                api in
                completionHandler(api.0, api.1)
                //completionHandler(api.clientReturn, api.movie)
            }
        case 1:
            MovieMDB.toprated(apikey, language: "en", page: page){
                api in
                completionHandler(api.0, api.1)
            }
        case 2:
            MovieMDB.nowplaying(apikey, language: "en", page: page){
                api in
                completionHandler(api.0, api.1)
            }
        default: break
        }
        
    }
}

