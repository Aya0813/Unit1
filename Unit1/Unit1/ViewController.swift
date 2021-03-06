//
//  ViewController.swift
//  Unit1
//
//  Created by NYUAD on 9/24/21.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var TableView: UITableView!
    
    var movies = [[String:Any]] () // array of dictionaries

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TableView.dataSource = self
        TableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                self.movies = dataDictionary ["results"] as! [[String: Any ]]
                self.TableView.reloadData() // it calls the functions again
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
             }
        }
        task.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //for recycle cell
        
        let movie = movies[indexPath.row]
        let title = movie ["title"] as! String //casting = means i would like the type to be string 
        let synopsis = movie ["overview"] as! String
        
        cell.titleLabel.text = title
        cell.SynopsisLabel.text = synopsis
        
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL (string: baseURL + posterPath )
        
        cell.PosterView.af_setImage(withURL: posterUrl!) // give me the URL and i ll eventually take care of dowloading it and setting the image
        return cell
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details screen" )
        
        
        //Find the selected movie
        
        let cell = sender as! UITableViewCell
        let indexPath = TableView.indexPath(for: cell)!
        let movie = movies [indexPath.row]
        
        //Pass the selected movie to the details view controller
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        TableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
 

    
    
    
}

