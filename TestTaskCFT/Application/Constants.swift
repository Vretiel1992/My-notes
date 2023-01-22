//
//  Constants.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//

import UIKit

enum Constants {
    enum Colors {
        static var backgroundPrimary = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return #colorLiteral(red: 0, green: 0.01561404299, blue: 0.302100122, alpha: 1)
            default:
                return UIColor(
                    red: 213/255,
                    green: 233/255,
                    blue: 255/255,
                    alpha: 1
                )
            }
        }

        static var backgroundSecondary = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return #colorLiteral(red: 0.500066936, green: 0.5033903122, blue: 0.5033316612, alpha: 0.1957609517)
            default:
                return UIColor(
                    red: 255/255,
                    green: 255/255,
                    blue: 255/255,
                    alpha: 0.7
                )
            }
        }
    }

    enum Fonts {
        static var systemFont18Bold: UIFont? {
            UIFont.systemFont(ofSize: 18, weight: .bold)
        }
        static var systemFont16Regular: UIFont? {
            UIFont.systemFont(ofSize: 16)
        }
    }

    enum Text {
        static let titleMainVC = "Заметки"
        static let titleEmpty = ""
        static let titleLabelBlankNoteVC = "Заголовок"
        static let descriptionLabelBlankNoteVC = "Описание"
        static let backButtonTitle = "Назад"
        static let readyNewNoteBarButtonItem = "Готово"
        static let placeholderSearchBar = "Поиск"
        static let cancelButtonText = "Отменить"
        static let keyCancelButtonText = "cancelButtonText"
        static let alertTitleEmptyFields = "Не заполнены пустые поля"
        static let alertOK = "Ок"
        static let dateFormat = "dd.MM.yyyy HH:mm:ss"
        static let customCell = "customCell"
        static let defaultCell = "defaultCell"
    }

    enum Images {
        static let trashFill = UIImage(systemName: "trash.fill")
        static let addNote = UIImage(systemName: "square.and.pencil")
    }

    enum Constraint {
        static let indent5 = 5.0
        static let indent16 = 16.0
    }
}
