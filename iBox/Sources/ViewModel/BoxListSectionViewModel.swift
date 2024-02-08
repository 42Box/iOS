//
//  BoxListSectionViewModel.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Foundation

class BoxListSectionViewModel: Identifiable {
    private var folder: Folder
    private var originalBoxListCellViewModels: [BoxListCellViewModel]!
    
    init(folder: Folder) {
        self.folder = folder
        originalBoxListCellViewModels = folder.bookmarks.map { BoxListCellViewModel(bookmark: $0) }
    }
    
    var boxListCellViewModels: [BoxListCellViewModel] {
        return isOpened ? originalBoxListCellViewModels : []
    }
    
    let id = UUID()
    
    var name: String {
        folder.name
    }
    
    var color: ColorName {
        folder.color
    }
    
    var isOpened: Bool {
        get {
            folder.isOpened
        }
        
        set {
            folder.isOpened = newValue
        }
    }
}
