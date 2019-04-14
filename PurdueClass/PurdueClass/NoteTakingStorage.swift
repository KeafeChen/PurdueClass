import CoreData

class NoteTakingStorage {
    static let storage : NoteTakingStorage = NoteTakingStorage()
    
    private var noteIndexToIdDict : [Int:UUID] = [:]
    private var currentIndex : Int = 0

    private(set) var managedObjectContext : NSManagedObjectContext
    private var managedContextHasBeenSet : Bool = false
    
    private init() {
        managedObjectContext = NSManagedObjectContext(
            concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
    
    func setManagedContext(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.managedContextHasBeenSet = true
        let notes = NoteTakingCoreDataHelper.readNotesFromCoreData(fromManagedObjectContext: self.managedObjectContext)
        currentIndex = NoteTakingCoreDataHelper.count
        for (index, note) in notes.enumerated() {
            noteIndexToIdDict[index] = note.noteId
        }
    }
    
    func addNote(noteToBeAdded: NoteTaking) {
        if managedContextHasBeenSet {
            // add note UUID to the dictionary
            noteIndexToIdDict[currentIndex] = noteToBeAdded.noteId
            NoteTakingCoreDataHelper.createNoteInCoreData(
                noteToBeCreated:          noteToBeAdded,
                intoManagedObjectContext: self.managedObjectContext)
            // increase index
            currentIndex += 1
        }
    }
    
    func removeNote(at: Int) {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                return
            }
            // get note UUID from the dictionary
            let noteUUID = noteIndexToIdDict[at]
            NoteTakingCoreDataHelper.deleteNoteFromCoreData(
                noteIdToBeDeleted:        noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            // update noteIndexToIdDict dictionary
            // the element we removed was not the last one: update GUID's
            if (at < currentIndex - 1) {
                // currentIndex - 1 is the index of the last element
                // but we will remove the last element, so the loop goes only
                // until the index of the element before the last element
                // which is currentIndex - 2
                for i in at ... currentIndex - 2 {
                    noteIndexToIdDict[i] = noteIndexToIdDict[i+1]
                }
            }
            // remove the last element
            noteIndexToIdDict.removeValue(forKey: currentIndex)
            // decrease current index
            currentIndex -= 1
        }
    }
    
    func readNote(at: Int) -> NoteTaking? {
        if managedContextHasBeenSet {
            // check input index
            if at < 0 || at > currentIndex-1 {
                return nil
            }
            // get note UUID from the dictionary
            let noteUUID = noteIndexToIdDict[at]
            let noteReadFromCoreData: NoteTaking?
            noteReadFromCoreData = NoteTakingCoreDataHelper.readNoteFromCoreData(
                noteIdToBeRead:           noteUUID!,
                fromManagedObjectContext: self.managedObjectContext)
            return noteReadFromCoreData
        }
        return nil
    }
    
    func changeNote(noteToBeChanged: NoteTaking) {
        if managedContextHasBeenSet {
            // check if UUID is in the dictionary
            var noteToBeChangedIndex : Int?
            noteIndexToIdDict.forEach { (index: Int, noteId: UUID) in
                if noteId == noteToBeChanged.noteId {
                    noteToBeChangedIndex = index
                    return
                }
            }
            if noteToBeChangedIndex != nil {
                NoteTakingCoreDataHelper.changeNoteInCoreData(
                noteToBeChanged: noteToBeChanged,
                inManagedObjectContext: self.managedObjectContext)
            } else {
            }
        }
    }

    
    func count() -> Int {
        return NoteTakingCoreDataHelper.count
    }
}
