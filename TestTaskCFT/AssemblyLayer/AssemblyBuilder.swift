//
//  AssemblyBuilder.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 26.12.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createBlankNoteModule(router: RouterProtocol, note: Note?) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createBlankNoteModule(router: RouterProtocol, note: Note?) -> UIViewController {
        let view = BlankNoteViewController()
        let presenter = BlankNotePresenter(view: view, router: router, note: note)
        view.presenter = presenter
        return view
    }
}
