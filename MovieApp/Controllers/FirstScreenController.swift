//
//  ViewController.swift
//  MovieApp
//
//  Created by Dzejlana Redzic on 10/8/20.
//

import UIKit
import CoreData

class FirstScreenController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var searchList = [SearchItem]()
    var moviesList = [Movie]()
    var currentPage = 0
    var totalPages = 0
    var query : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        loadSearchItems()
        tableView.isHidden = true
    }
    
    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchItemCell", for: indexPath)
        cell.textLabel?.text = searchList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        APICall(query: searchList[indexPath.row].title!.lowercased(), page: 1)
    }
    
    //SearchBar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tableView.isHidden = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0{
            createAlert(message: "Enter a movie name")
        }
        
        else{
            APICall(query: searchBar.text!.lowercased(), page: 1)
            searchBar.text?.removeAll()
        }
    }
    
    //Core Data
    func saveSearchItems(){
        do{
            try context.save()
        }
        catch{
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadSearchItems(){
        let request : NSFetchRequest<SearchItem> = SearchItem.fetchRequest()
        do{
            searchList = try context.fetch(request).reversed()
        }
        catch{
            print("Error fetching data from context, \(error)")
        }
    }
    
    //Additional functions
    func addToList(search: String){
        let newSearch = SearchItem(context: context)
        newSearch.title = search.lowercased()
        
        for search in searchList{
            if search.title?.lowercased() == newSearch.title?.lowercased(){
                return
            }
        }
        
        if(searchList.count >= 10){
            let lastItem = searchList.removeLast()
            context.delete(lastItem)
        }
        searchList.insert(newSearch, at: 0)
        saveSearchItems()
    }
    
    func APICall(query: String, page: Int){
        let movieRequest = MovieRequest(query: query, page: page)
        movieRequest.getMovies{ [weak self] result in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let movies):
                DispatchQueue.main.async {
                    if(movies.results.count == 0){
                        self?.createAlert(message: "No results")
                    }
                    else{
                        self?.moviesList = movies.results
                        self?.totalPages = movies.total_pages
                        self?.currentPage = movies.page
                        self?.query = query
                        self?.performSegue(withIdentifier: "showMovieList", sender: self)
                        self?.addToList(search: query)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SecondScreenController
        if moviesList.count != 0 {
            destinationVC.movies = moviesList
            destinationVC.totalPages = totalPages
            destinationVC.currentPage = currentPage
            destinationVC.query = query
        }
    }
    
    func createAlert(message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


