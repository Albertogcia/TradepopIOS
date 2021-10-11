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
                        return Product.parseDataFromFirebase(document: document)
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
    
    func getUserProducts(userUuid: String, completion: @escaping (Error?, [Product]?) -> ()) {
        db.collection(PRODUCTS_COLLECTION_KEY).whereField("owner", isEqualTo: userUuid).order(by: "date", descending: true).getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    var products: [Product] = []
                    products = snapshot.documents.map { document in
                        return Product.parseDataFromFirebase(document: document)
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
