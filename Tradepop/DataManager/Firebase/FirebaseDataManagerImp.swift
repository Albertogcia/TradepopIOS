//
//  FirebaseDataManagerImp.swift
//  Tradepop
//
//  Created by Alberto García Antuña on 30/9/21.
//

import Firebase
import Foundation

private let PRODUCTS_COLLECTION_KEY = "products"
private let TRANSACTIONS_COLLECTION_KEY = "transactions"

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

    func getAllProducts(userUuid: String?, completion: @escaping (Error?, [Product]?) -> ()) {
        var query = db.collection(PRODUCTS_COLLECTION_KEY).order(by: "date", descending: true)
        if let userUuid = userUuid{
            query = db.collection(PRODUCTS_COLLECTION_KEY).whereField("owner", isNotEqualTo: userUuid).order(by: "owner", descending: true).order(by: "date", descending: true)
        }
        query.getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    var products: [Product] = []
                    products = snapshot.documents.map { document in
                        Product.parseDataFromFirebase(document: document)
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
                        Product.parseDataFromFirebase(document: document)
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

    func deleteProduct(uuid: String, completion: @escaping (Error?) -> ()) {
        db.collection(PRODUCTS_COLLECTION_KEY).document(uuid).delete() { error in
            completion(error)
        }
    }

    func buyProduct(productUuid: String, buyerUuid: String, buyerName: String, sellerUuid: String, sellerName: String, price: Double, productName: String, completion: @escaping (Error?) -> ()) {
        db.collection(TRANSACTIONS_COLLECTION_KEY).addDocument(data: [
            "buyerUuid": buyerUuid,
            "buyerName": buyerName,
            "sellerUuid": sellerUuid,
            "sellerName": sellerName,
            "price": price,
            "productName": productName,
            "date": Date()
        ]) { error in
            if error == nil {
                self.db.collection(PRODUCTS_COLLECTION_KEY).document(productUuid).delete() { error in
                    completion(error)
                }
            }
            else {
                completion(error)
            }
        }
    }

    func updateImage(imageData: Data, completion: @escaping (String?, Error?) -> ()) {
        let uuid = UUID().uuidString.lowercased().appending(".jpeg")
        let imageRef = storageReference.child(uuid)
        imageRef.putData(imageData, metadata: nil) { _, error in
            if error == nil {
                imageRef.downloadURL { url, error in
                    if let url = url {
                        completion(url.absoluteString, error)
                    }
                    else {
                        completion(nil, error)
                    }
                }
            }
            else {
                completion(nil, error)
            }
        }
    }

    func updateProduct(productUuid: String, title: String, description: String, price: Double, categoryId: Int, coverImageUrl: String, completion: @escaping (Error?) -> ()) {
        db.collection(PRODUCTS_COLLECTION_KEY).document(productUuid).setData([
            "title": title,
            "description": description,
            "price": price,
            "categoryId": categoryId,
            "coverImageUrl": coverImageUrl
        ], merge: true) { error in
            completion(error)
        }
    }
}
