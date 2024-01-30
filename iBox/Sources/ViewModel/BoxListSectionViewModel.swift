//
//  BoxListSectionViewModel.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Foundation

class BoxListSectionViewModel: Identifiable {
    private var folder: Folder
    var boxListCellViewModels: [BoxListCellViewModel]!
    
    init(folder: Folder) {
        self.folder = folder
        boxListCellViewModels = folder.bookmarks.map { BoxListCellViewModel(bookmark: $0) }
    }
    
    let id = UUID()
    
    var name: String {
        folder.name
    }
    
    var color: ColorName {
        folder.color
    }
    
    var isOpen: Bool {
        get {
            folder.isOpened
        }
        
        set {
            folder.isOpened = newValue
        }
    }
}
