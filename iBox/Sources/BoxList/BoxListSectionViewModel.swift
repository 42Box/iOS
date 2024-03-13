//
//  BoxListSectionViewModel.swift
//  iBox
//
//  Created by 이지현 on 1/30/24.
//

import Foundation

class BoxListSectionViewModel: Identifiable {
    var folder: Folder {
        didSet {
            boxListCellViewModels = folder.bookmarks.map { BoxListCellViewModel(bookmark: $0) }
        }
    }
    private var boxListCellViewModels: [BoxListCellViewModel]!
    
    init(folder: Folder) {
        self.folder = folder
        boxListCellViewModels = folder.bookmarks.map { BoxListCellViewModel(bookmark: $0) }
    }
    
    var id: UUID {
        folder.id
    }
    
    var name: String {
        get {
            folder.name
        }
        set {
            folder.name = newValue
        }
    }
    
    var isOpened: Bool = false
    
    
    var boxListCellViewModelsWithStatus: [BoxListCellViewModel] {
        return isOpened ? boxListCellViewModels : []
    }
    
    func viewModel(at index: Int) -> BoxListCellViewModel {
        return boxListCellViewModels[index]
    }
    
    @discardableResult
    func deleteCell(at index: Int) -> BoxListCellViewModel {
        let cell = boxListCellViewModels[index]
        boxListCellViewModels.remove(at: index)
        return cell
    }
    
    func updateCell(at index: Int, bookmark: Bookmark) {
        boxListCellViewModels[index].bookmark = bookmark
    }
    
    func insertCell(_ cell: BoxListCellViewModel, at index: Int) {
        boxListCellViewModels.insert(cell, at: index)
    } 
}

