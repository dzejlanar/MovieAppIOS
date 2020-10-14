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
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == movies.count - 1{
            if(currentPage < totalPages){
                currentPage = currentPage + 1
                APICall(query: query, page: currentPage)
            }
        }
        
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

    func APICall(query: String, page: Int){
        let movieRequest = MovieRequest(query: query, page: page)
        movieRequest.getMovies{ [weak self] result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let movies):
                DispatchQueue.main.async {
                    if(movies.total_results > 0){
                        self?.movies.append(contentsOf: movies.results)
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}
