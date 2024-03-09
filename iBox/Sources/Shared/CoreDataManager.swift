//
//  CoreDataManager.swift
//  iBox
//
//  Created by 이지현 on 2/9/24.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer = {
        let container = NSPersistentContainer(name: "iBox")
    
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
        
        return container
    }()
    
    private init() {}
    
    private var lastFolderOrder: Int64 = 0
    private var lastBookmarkOrder = [UUID: Int64]()
    
    private func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Fail to save the context:", error.localizedDescription)
        }
    }
}

// 폴더 관련
extension CoreDataManager {
    func addInitialFolders(_ folders: [Folder]) {
        let context = persistentContainer.viewContext
        
        for folder in folders {
            let newFolder = FolderEntity(context: context)
            newFolder.id = folder.id
            newFolder.name = folder.name
            newFolder.order = lastFolderOrder
            lastFolderOrder += 1
            let bookmarks = NSMutableOrderedSet()
            lastBookmarkOrder[folder.id] = 0
            for bookmark in folder.bookmarks {
                let newBookmark = BookmarkEntity(context: context)
                newBookmark.id = bookmark.id
                newBookmark.name = bookmark.name
                newBookmark.url = bookmark.url
                newBookmark.order = lastBookmarkOrder[folder.id] ?? 0
                lastBookmarkOrder[folder.id] = (lastBookmarkOrder[folder.id] ?? 0) + 1
                bookmarks.add(newBookmark)
            }
            newFolder.bookmarks = bookmarks
        }
        save()
    }
    
    func addFolder(_ folder: Folder) {
        let context = persistentContainer.viewContext
        let newFolder = FolderEntity(context: context)
        newFolder.id = folder.id
        newFolder.name = folder.name
        newFolder.order = lastFolderOrder
        lastFolderOrder += 1
        let bookmarks = NSMutableOrderedSet()
        lastBookmarkOrder[folder.id] = 0
        for bookmark in folder.bookmarks {
            let newBookmark = BookmarkEntity(context: context)
            newBookmark.id = bookmark.id
            newBookmark.name = bookmark.name
            newBookmark.url = bookmark.url
            newBookmark.order = lastBookmarkOrder[folder.id] ?? 0
            lastBookmarkOrder[folder.id] = (lastBookmarkOrder[folder.id] ?? 0) + 1
            bookmarks.add(newBookmark)
        }
        newFolder.bookmarks = bookmarks
        save()
    }
    
    private func getFolderEntity(id: UUID) -> FolderEntity? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getAllFolderEntity() -> [FolderEntity] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = FolderEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func getFolders() -> [Folder] {
        let folderEntities = getAllFolderEntity()
        var folders = [Folder]()
        
        lastFolderOrder = (folderEntities.last?.order ?? -1) + 1
        for folderEntity in folderEntities {
            let bookmarkEntities = (folderEntity.bookmarks?.array as? [BookmarkEntity] ?? []).sorted {
                $0.order < $1.order
            }
            guard let folderId = folderEntity.id else { return [] }
            lastBookmarkOrder[folderId] = (bookmarkEntities.last?.order ?? -1) + 1
            let bookmarks = bookmarkEntities.map{ Bookmark(id: $0.id ?? UUID(), name: $0.name ?? "" , url: $0.url ?? URL(string: "")!) }
            folders.append(Folder(id: folderEntity.id ?? UUID(), name: folderEntity.name ?? "", bookmarks: bookmarks))
        }
        
        return folders
    }
    
    func deleteFolder(id: UUID) {
        let context = persistentContainer.viewContext
        
        guard let folder = getFolderEntity(id: id) else { return }
        let deletedOrder = folder.order
        context.delete(folder)
        
        let subsequentFolderEntities = getAllFolderEntity().filter{ $0.order > deletedOrder }
        for folderEntity in subsequentFolderEntities {
            folderEntity.order -= 1
        }
        lastFolderOrder -= 1
        save()
    }
    
    func deleteAllFolders() {
        let context = persistentContainer.viewContext
        
        let folders = getAllFolderEntity()
        for folder in folders {
            context.delete(folder)
        }
        save()
    }
    
    func updateFolder(id: UUID, name: String) {
        guard let folder = getFolderEntity(id: id) else { return }
        folder.name = name
        save()
    }
    
    func moveFolder(from source: Int, to destination: Int) {
        let folderEntities = getAllFolderEntity()
        
        if source < destination {
            var startIndex = source + 1
            let endIndex = destination
            var startOrder = folderEntities[source].order
            while startIndex <= endIndex {
                folderEntities[startIndex].order = startOrder
                startOrder += 1
                startIndex += 1
            }
            folderEntities[source].order = startOrder
        } else if destination < source {
            var startIndex = destination
            let endIndex = source - 1
            var startOrder = folderEntities[destination].order + 1
            let newOrder = folderEntities[destination].order
            while startIndex <= endIndex {
                folderEntities[startIndex].order = startOrder
                startOrder += 1
                startIndex += 1
            }
            folderEntities[source].order = newOrder
        }
        save()
    }
    
}

// 북마크 관련
extension CoreDataManager {
    
    func addBookmark(_ bookmark: Bookmark, folderId: UUID) {
        let context = persistentContainer.viewContext
        
        guard let folder = getFolderEntity(id: folderId) else { return }
        let newBookmark = BookmarkEntity(context: context)
        newBookmark.id = bookmark.id
        newBookmark.name = bookmark.name
        newBookmark.url = bookmark.url
        guard let folderId = folder.id else { return }
        newBookmark.order = lastBookmarkOrder[folderId] ?? 0
        lastBookmarkOrder[folderId] = (lastBookmarkOrder[folderId] ?? 0) + 1
        newBookmark.folder = folder
        save()
    }
    
    func updateBookmark(id: UUID, name: String, url: URL) {
        guard let bookmark = getBookmarkEntity(id: id) else { return }
        bookmark.name = name
        bookmark.url = url
        save()
    }
    
    private func getBookmarkEntity(id: UUID) -> BookmarkEntity? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = BookmarkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteBookmark(id: UUID) {
        let context = persistentContainer.viewContext
        
        guard let bookmark = getBookmarkEntity(id: id) else { return }
        let deletedOrder = bookmark.order
        context.delete(bookmark)
        
        guard let folderId = bookmark.folder?.id else { return }
        let subsequentBookmarkEntities = getAllBookmarkEntity(in: folderId).filter{ $0.order > deletedOrder }
        for bookmarkEntity in subsequentBookmarkEntities {
            bookmarkEntity.order -= 1
        }
        lastBookmarkOrder[folderId] = (lastBookmarkOrder[folderId] ?? 1) - 1
        save()
    }
    
    private func getAllBookmarkEntity(in folderId: UUID) -> [BookmarkEntity] {
        let context = persistentContainer.viewContext
        
        guard let folder = getFolderEntity(id: folderId) else { return [] }
        let fetchRequest = BookmarkEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "folder == %@", folder)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteAllBookmarks(folderId: UUID) {
        let context = persistentContainer.viewContext
        
        let bookmarks = getAllBookmarkEntity(in: folderId)
        for bookmark in bookmarks {
            context.delete(bookmark)
        }
        save()
    }
    
    func moveBookmark(from source: IndexPath, to destination: IndexPath, srcId: UUID) {
        if source.section == destination.section {
            guard let bookmarkEntity = getBookmarkEntity(id: srcId) else { return }
            guard let folderId = bookmarkEntity.folder?.id else { return }
            let bookmarkEntities = getAllBookmarkEntity(in: folderId)
            let source = source.row
            let destination = destination.row
            if source < destination {
                var startIndex = source + 1
                let endIndex = destination
                var startOrder = bookmarkEntity.order
                while startIndex <= endIndex {
                    bookmarkEntities[startIndex].order = startOrder
                    startOrder += 1
                    startIndex += 1
                }
                bookmarkEntities[source].order = startOrder
            } else if destination < source {
                var startIndex = destination
                let endIndex = source - 1
                var startOrder = bookmarkEntities[destination].order + 1
                let newOrder = bookmarkEntities[destination].order
                while startIndex <= endIndex {
                    bookmarkEntities[startIndex].order = startOrder
                    startOrder += 1
                    startIndex += 1
                }
                bookmarkEntities[source].order = newOrder
            }
        } else {
            guard let srcBookmarkEntity = getBookmarkEntity(id: srcId) else { return }
            guard let srcFolderId = srcBookmarkEntity.folder?.id else { return }
            let deletedOrder = srcBookmarkEntity.order
            let srcBookmarkEntities = getAllBookmarkEntity(in: srcFolderId).filter{ $0.order > deletedOrder }
            for bookmarkEntity in srcBookmarkEntities {
                bookmarkEntity.order -= 1
            }
            lastBookmarkOrder[srcFolderId] = (lastBookmarkOrder[srcFolderId] ?? 1) - 1
            
            let folderEntities = getAllFolderEntity()
            let destFolder = folderEntities[destination.section]
            guard let destFolderId = destFolder.id else { return }
            let destinationOrder = Int64(destination.row)
            let destBookmarkEntities = getAllBookmarkEntity(in: destFolderId).filter{ $0.order >= deletedOrder }
            for bookmarkEntity in destBookmarkEntities {
                bookmarkEntity.order += 1
            }
            lastBookmarkOrder[destFolderId] = (lastBookmarkOrder[destFolderId] ?? 0) + 1
            
            
            srcBookmarkEntity.folder = destFolder
            srcBookmarkEntity.order = destinationOrder
        }
        save()
    }
    
}

