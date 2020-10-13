//
//  SecondScreenController.swift
//  MovieApp
//
//  Created by Dzejlana Redzic on 10/8/20.
//

import UIKit

class SecondScreenController: UITableViewController {
    
    var movies = [Movie](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var totalPages = 0
    var currentPage = 1
    var query: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieListCell
        
        if movies[indexPath.row].poster_path != nil {
            let imageString = "https://image.tmdb.org/t/p/w92" + movies[indexPath.row].poster_path!

            guard let imageURL = URL(string: imageString) else { fatalError() }
            guard let imageData = try? Foundation.Data(contentsOf: imageURL) else { fatalError() }
            let image = UIImage(data: imageData)
            cell.moviePoster.image = image
        }

        cell.movieTitle.text = movies[indexPath.row].title
        cell.releaseDate.text = movies[indexPath.row].release_date
        cell.overview.text = movies[indexPath.row].overview
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
