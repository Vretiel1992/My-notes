//
//  Router.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 26.12.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showBlankNewNote(note: Note?)
}

class Router: RouterProtocol {

    // MARK: - Public Properties

    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?

    // MARK: - Protocol Methods

    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showBlankNewNote(note: Note?) {
        if let navigationController = navigationController {
            guard let newNoteViewController = assemblyBuilder?.createBlankNoteModule(router: self, note: note) else { return }
            navigationController.pushViewController(newNoteViewController, animated: true)
        }
    }
}
