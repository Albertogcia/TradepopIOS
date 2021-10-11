//
//  FirebaseDataManagerImp.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 30/9/21.
//

import Firebase
import Foundation

private let PRODUCTS_COLLECTION_KEY = "products"

class FirebaseDataManagerImp: FirebaseDataManager {

    let db = Firestore.firestore()

    let storage = Storage.storage()
    lazy var storageReference: StorageReference = {
        storage.reference()
    }()

    func createNewProduct(imageData: Data, title: String, description: String, categoryId: Int, price: Double, userUuid: String, userName: String, completion: @escaping (Error?) -> ()) {
        let uuid = UUID().uuidString.lowercased().appending(".jpeg")
        let imageRef = storageReference.child(uuid)
        imageRef.putData(imageData, metadata: nil) { _, error in
            if error == nil {
                imageRef.downloadURL { url, error in
                    if error == nil {
                        if let url = url {
                            self.db.collection(PRODUCTS_COLLECTION_KEY).addDocument(data: [
                                "title": title,
                                "description": description,
                                "categoryId": categoryId,
                                "price": price,
                                "owner": userUuid,
                                "ownerName": userName,
                                "coverImageUrl": url.absoluteString,
                                "date": Date()
                            ]) { error in
                                completion(error)
                            }
                        }
                    }
                    else {
                        completion(error)
                    }
                }
            }
            else {
                completion(error)
            }
        }
    }

    func getAllProducts(completion: @escaping (Error?, [Product]?) -> ()) {
        db.collection(PRODUCTS_COLLECTION_KEY).order(by: "date", descending: true).getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    var products: [Product] = []
                    products = snapshot.documents.map { document in
                        let documentData = document.data()
                        let documentUuid = document.documentID
                        let title = documentData["title"] as? String
                        let description = documentData["description"] as? String
                        let price = documentData["price"] as? Double
                        let categoryId = documentData["categoryId"] as? Int
                        let ownerUuid = documentData["owner"] as? String
                        let ownerName = documentData["ownerName"] as? String
                        let date = (documentData["date"] as? Timestamp)?.dateValue()
                        let coverImageUrl = documentData["coverImageUrl"] as? String
                        return Product(uuid: documentUuid, title: title, description: description, price: price, categoryId: categoryId, ownerUuid: ownerUuid, ownerName: ownerName, date: date, coverImageUrl: coverImageUrl)
                    }
                    completion(nil, products)
                }
                else {
                    completion(error, nil)
                }
            }
            else {
                completion(error, nil)
            }
        }
    }
}
