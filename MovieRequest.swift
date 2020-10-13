//
//  MovieRequest.swift
//  MovieApp
//
//  Created by Dzejlana Redzic on 10/12/20.
//

import Foundation

enum MovieError:Error{
    case noDataAvailable
    case canNotProcesData
}

struct MovieRequest {
    let resourceURL: URL
    let API_KEY = "2696829a81b1b5827d515ff121700838"
    
    init(query:String, page:Int) {
        
        let resourceString = "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&query=\(query)&page=\(page)"
        let URLString = resourceString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let resourceURL = URL(string: URLString!) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func getMovies(completion: @escaping(Result<MovieResponse, MovieError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: jsonData)
                let movies = movieResponse
                completion(.success(movies))
            }
            catch{
                completion(.failure(.canNotProcesData))
            }
        }
        dataTask.resume()
    }
}
