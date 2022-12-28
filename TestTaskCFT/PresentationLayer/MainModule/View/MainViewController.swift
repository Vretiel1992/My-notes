//
//  MainViewController.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func notesLoad(notes: [Note])
    func noteAddSuccess(note: Note)
    func noteDeletion(indexPath: IndexPath)
}

final class MainViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: MainViewPresenterProtocol?
    var notes: [Note] = []

    // MARK: - Private Properties
    
    private lazy var addNoteBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: Constants.Images.addNote,
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        return item
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.Text.placeholderSearchBar
        return searchController
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Constants.Text.defaultCell)
        tableView.register(MainCustomTableViewCell.self,
                           forCellReuseIdentifier: Constants.Text.customCell)
        tableView.backgroundColor = Constants.Colors.backgroundPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var filteredNotes = [Note]()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupConstraints()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.Text.titleMainVC
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = Constants.Text.titleEmpty
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundPrimary
        view.addSubview(tableView)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Constants.Text.titleMainVC
        navigationItem.backButtonTitle = Constants.Text.backButtonTitle
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = addNoteBarButtonItem

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = Constants.Colors.backgroundPrimary
        navBarAppearance.shadowImage = nil
        navBarAppearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Object Methods

    @objc func addTapped() {
        presenter?.addTapped(at: nil)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering { return filteredNotes.count }
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.Text.customCell,
            for: indexPath
        ) as? MainCustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.Text.defaultCell,
                for: indexPath
            )
            return cell
        }

        var filterNote: Note
        filterNote = isFiltering
        ? filteredNotes[indexPath.row]
        : notes[indexPath.row]

        cell.configure(with: filterNote)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            self.presenter?.deleteSelected(for: indexPath)
            completion(true)
        }
        deleteAction.image = Constants.Images.trashFill
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if !isFiltering {
            presenter?.addTapped(at: indexPath.row)
        }
    }
}

// MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    func notesLoad(notes: [Note]) {
        self.notes = notes
        tableView.reloadData()
    }

    func noteAddSuccess(note: Note) {
        self.notes.append(note)
        tableView.reloadData()
    }

    func noteDeletion(indexPath: IndexPath) {
        let index = indexPath.row
        notes.remove(at: index)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    private func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter({ (note: Note) -> Bool in
            return note.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
