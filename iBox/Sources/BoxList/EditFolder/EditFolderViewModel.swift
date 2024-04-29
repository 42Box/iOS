//
//  EditFolderViewModel.swift
//  iBox
//
//  Created by 이지현 on 3/11/24.
//

import Combine
import Foundation

protocol EditFolderViewModelDelegate: AnyObject {
    func reloadRow(_ indexPath: IndexPath)
    func deleteRow(_ indexPath: IndexPath)
    func reloadTableView()
    func addRow()
}

class EditFolderViewModel {
    weak var delegate: EditFolderViewModelDelegate?
    var folderList: [Folder]
    
    private let output = PassthroughSubject<Bool, Never>()
    
    init(folderList: [Folder]) {
        self.folderList = folderList
    }
    
    var folderCount: Int {
        folderList.count
    }
    
    func addFolder(_ folder: Folder) {
        CoreDataManager.shared.addFolder(folder)
        folderList.append(folder)
        delegate?.addRow()
    }
    
    func deleteFolder(at indexPath: IndexPath) {
        CoreDataManager.shared.deleteFolder(id: folderList[indexPath.row].id)
        folderList.remove(at: indexPath.row)
        delegate?.deleteRow(indexPath)
    }
    
    func editFolderName(at indexPath: IndexPath, name: String) {
        CoreDataManager.shared.updateFolder(id: folderList[indexPath.row].id, name: name)
        folderList[indexPath.row].name = name
        delegate?.reloadRow(indexPath)
    }
    
    func folderName(at indexPath: IndexPath) -> String {
        return folderList[indexPath.row].name
    }
    
    func reorderFolder(srcIndexPath: IndexPath, destIndexPath: IndexPath) {
        let mover = folderList.remove(at: srcIndexPath.row)
        folderList.insert(mover, at: destIndexPath.row)
        CoreDataManager.shared.moveFolder(from: srcIndexPath.row, to: destIndexPath.row)
    }
}
