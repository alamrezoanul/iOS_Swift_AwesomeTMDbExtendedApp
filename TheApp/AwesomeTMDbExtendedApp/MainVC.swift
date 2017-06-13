//
//  MainVC.swift
//  AwesomeTMDbExtendedApp
//
//  Created by TAHIYAH ALAM KHAN on 4/14/17.
//  Copyright © 2017 Rezoanul Alam Riad. All rights reserved.
//

import UIKit
import TMDBSwift


let apikey = "b9bd855f302ce4c0e7b2fc8e308e56ff" //alamrezoanul
let imageBaseUrl300 = "http://image.tmdb.org/t/p/w300"
let imageBaseUrl500 = "http://image.tmdb.org/t/p/w500"
let imageBaseUrl780 = "http://image.tmdb.org/t/p/w780"

struct movies{
    var id: Int?
    var genreName: String?
    var movie: [MovieMDB]?
    init(id_: Int?, genreName_: String?, movies_: [MovieMDB]?){
        id = id_
        genreName = genreName_
        movie = movies_
    }
}

class MainVC: UIViewController {
    
    var dataSource = [movies]()
    var dlIndex = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GenresMDB.genres(apikey, listType: GenresListType(rawValue: "movie")!, language: "en"){
            api in
            let genresCount = api.1?.count ?? 0
            for i in 0..<genresCount{
                self.dataSource.append(movies.init(id_: api.1![i].id, genreName_: api.1![i].name, movies_: nil))
            }
            self.getMovies()
        }
    }
    
    
    
    func getMovies(){
        if(dlIndex < dataSource.count){
            
            GenresMDB.genre_movies(apikey, genreId: dataSource[dlIndex].id!, include_adult_movies: true, language: "en"){
                api in
                print(api.1?[self.dlIndex] ?? "NO DATA!")
                
                self.dataSource[self.dlIndex].movie = api.1!
                self.dlIndex += 1
                self.getMovies()
            }
            
        }else{
            handleTableViewData{
                _ in
            }
        }
    }
    
    
    func handleTableViewData(_ completionHandler: (Bool) -> ()) -> (){
        print(dataSource[5].movie![0].original_title ?? "")
        completionHandler(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
