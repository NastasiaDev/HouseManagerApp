//
//  ListOfObjectsViewController.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

// MARK: - Models

struct ObjectData: Decodable {
    let date: String
    let objects: [String]
}

struct APIResponse: Decodable {
    let data: [ObjectData]
}

final class ListOfObjectsViewController: UIViewController {
    // MARK: - Properties

    private var groupedObjects: [String: [String]] = [:]
    private let networkService: NetworkServiceProtocol = NetworkService()

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.setupUI()
    }
}

// MARK: - UI Setup

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

// MARK: - Fetch Data

private extension ListOfObjectsViewController {
    private func fetchData() {
        self.networkService.fetchObjects { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(objects):
                self.groupedObjects = ObjectDataConverter.groupObjectsByDate(objects)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ListOfObjectsViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return groupedObjects.keys.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = Array(groupedObjects.keys)[section]
        return groupedObjects[date]?.count ?? 0
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
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
