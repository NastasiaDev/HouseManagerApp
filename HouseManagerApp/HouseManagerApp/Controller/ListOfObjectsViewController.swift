//
//  ListOfObjectsViewController.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

struct ObjectData: Decodable {
    let date: String
    let objects: [String]
}

struct APIResponse: Decodable {
    let data: [ObjectData]
}

final class ListOfObjectsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var groupedObjects: [String: [String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.setupUI()
    }
}

private extension ListOfObjectsViewController {
    private func setupUI() {
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.view.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ObjectCell")
        self.tableView.showsVerticalScrollIndicator = false
    }
}

private extension ListOfObjectsViewController {
    private func fetchData() {
        guard let url = URL(string: "https://rozentalgroup.ru/test/test_ios.php") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                self.groupedObjects = self.groupObjectsByDate(apiResponse.data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error parsing data: \(error)")
            }
        }.resume()
    }
}

private extension ListOfObjectsViewController {
    private func groupObjectsByDate(_ data: [ObjectData]) -> [String: [String]] {
        var grouped: [String: [String]] = [:]
        
        for item in data {
            if let formattedDate = convertDate(dateString: item.date) {
                if grouped[formattedDate] == nil {
                    grouped[formattedDate] = []
                }
                grouped[formattedDate]?.append(contentsOf: item.objects)
            }
        }
        
        return grouped
    }
    
    private func convertDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}

extension ListOfObjectsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedObjects.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = Array(groupedObjects.keys)[section]
        return groupedObjects[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(groupedObjects.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = Array(groupedObjects.keys)[indexPath.section]
        let address = groupedObjects[date]?[indexPath.row] ?? ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectCell", for: indexPath)
        cell.textLabel?.text = address
        return cell
    }
}
