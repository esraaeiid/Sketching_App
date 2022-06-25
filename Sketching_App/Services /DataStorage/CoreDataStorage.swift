//
//  CoreDataStorage.swift
//  Sketching_App
//
//  Created by Esraa on 15/06/2022.
//

import Foundation
import CoreData

class CoreDataStorageManager {

    static let shared = CoreDataStorageManager()

    ///Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "SketchingApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}


class CoreDataStorage {
    private init() {}
    static let instance = CoreDataStorage()
    private let context = CoreDataStorageManager.shared.persistentContainer.viewContext



    /// helper method to save drawing data
    /// - Parameters:
    ///   - completionHandler: boolean handler will be true when data saved successfully
    ///   - model: DrawingModel
    ///
    private func save(completionHandler: @escaping(Bool) -> (), _ model: DrawingModel?) {
        let drawingModel = NSEntityDescription.insertNewObject(forEntityName: "DrawingDataModel", into: context) as! DrawingDataModel
        drawingModel.setValue(model?.id, forKey: "id")
        drawingModel.setValue(model?.drawing?.dataRepresentation(), forKey: "drawing")
        drawingModel.setValue(model?.name, forKey: "name")
        drawingModel.setValue(model?.date, forKey: "date")
        drawingModel.setValue(model?.thumbnail?.jpegData(compressionQuality: 1), forKey: "thumbnail")
        do{
            try context.save()
            completionHandler(true)
        } catch let saveIncErr {
            print("Failed to save \(saveIncErr)")
        }
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

    }

    /// helper method to fetch drawingData
    /// - Returns: DrawingDataModel
    ///
    func fetch() -> [DrawingDataModel]{
        let fetchRequset = NSFetchRequest<DrawingDataModel>(entityName: "DrawingDataModel")
        do{
            let drawingData = try context.fetch(fetchRequset)
            return drawingData

        } catch let fetchErr{
            print("failed, when tried to fetch \(fetchErr)")
        }

        return []
    }

    /// helper method to save drawing or update if it is already exist
    /// - Parameters:
    ///   - completionHandler: boolean handler will be true when data saved/ updated  successfully
    ///   - model: DrawingModel
    func saveDrawing(completionHandler: @escaping(Bool) -> (), model: DrawingModel?){
        isContain(model: model) ? update(completionHandler: { (bool) in completionHandler(bool)},
                                         model: model) : save(completionHandler: { (bool) in completionHandler(bool)}, model)
    }

    /// helper method to update drawing data on disk
    /// - Parameters:
    ///   - completionHandler: boolean handler will be true when data updated successfully
    ///   - model: DrawingModel
    private func update(completionHandler: @escaping(Bool) -> (), model: DrawingModel?) {
        guard self.fetch().map({$0.id}).contains(model?.id) else { return }
        self.fetch().filter({$0.id == model?.id}).forEach { (obj) in
            obj.name = model?.name
            obj.thumbnail = model?.thumbnail?.jpegData(compressionQuality: 1)
            obj.drawing = model?.drawing?.dataRepresentation()
            obj.date = model?.date
            do{
                try context.save()
                completionHandler(false)
            } catch let saveIncErr {
                print("Failed to delete \(saveIncErr)")
            }
        }

    }
    

    /// helper method to delete drawing data from disk
    /// - Parameters:
    ///   - completionHandler: boolean handler will be true when data deleted successfully
    ///   - model: DrawingModel
    func deleteDrawing(completionHandler: @escaping(Bool) -> (), model: DrawingModel?) {
        guard self.fetch().map({$0.id}).contains(model?.id) else { return }
        self.fetch().filter({$0.id == model?.id}).forEach { (obj) in
            self.context.delete(obj)
            do{
                try context.save()
                completionHandler(false)
            } catch let saveIncErr {
                print("Failed to delete \(saveIncErr)")
            }
        }

    }



    /// helper method to check wether drawingDataModel to save already exist or not
    /// - Parameter model: DrawingDataModel
    /// - Returns: Bool wthere data exist or not
    func isContain(model: DrawingModel?) -> Bool {
        return self.fetch().map({$0.id}).contains(model?.id)
    }



}

