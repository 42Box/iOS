//
//  EditFolderViewModel.swift
//  iBox
//
//  Created by 이지현 on 3/11/24.
//

import Combine
import Foundation

class EditFolderViewModel {
    var folderList: [Folder]
    
    init(folderList: [Folder]) {
        self.folderList = folderList
    }
    
    var folderCount: Int {
        folderList.count
    }
    
    func folderName(at indexPath: IndexPath) -> String {
        return folderList[indexPath.row].name
    }
}
