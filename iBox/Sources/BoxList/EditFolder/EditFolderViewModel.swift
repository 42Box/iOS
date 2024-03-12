//
//  EditFolderViewModel.swift
//  iBox
//
//  Created by 이지현 on 3/11/24.
//

import Combine
import Foundation

protocol EditFolderViewModelDelegate: AnyObject {
    func reloadTableView()
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
        delegate?.reloadTableView()
    }
    
    func deleteFolder(at indexPath: IndexPath) {
        CoreDataManager.shared.deleteFolder(id: folderList[indexPath.row].id)
        folderList.remove(at: indexPath.row)
        delegate?.reloadTableView()
    }
    
    func editFolderName(at indexPath: IndexPath, name: String) {
        CoreDataManager.shared.updateFolder(id: folderList[indexPath.row].id, name: name)
        folderList[indexPath.row].name = name
        delegate?.reloadTableView()
    }
    
    func folderName(at indexPath: IndexPath) -> String {
        return folderList[indexPath.row].name
    }
}
