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
private let USERS_COLLECTION_KEY = "users"

class FirebaseDataManagerImp: FirebaseDataManager {

    let db = Firestore.firestore()

    let storage = Storage.storage()
    lazy var storageReference: StorageReference = {
        storage.reference()
    }()

    private var userFavorites = [String]()

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
        if let userUuid = userUuid {
            getUserFavoritesList(userUuid: userUuid) { favorites in
                guard let favorites = favorites else { return }
                self.userFavorites = favorites
            }
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
        getUserFavoritesList(userUuid: userUuid) { favorites in
            guard let favorites = favorites else { return }
            self.userFavorites = favorites
        }
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

    func getProductsFromUserFavorites(userUuid: String, completion: @escaping (Error?, [Product]?) -> ()) {
        getUserFavoritesList(userUuid: userUuid) { favoritesList in
            guard let favoritesList = favoritesList, !favoritesList.isEmpty else { completion(nil, [Product]()); return }
            self.userFavorites = favoritesList
            self.db.collection(PRODUCTS_COLLECTION_KEY).whereField(FieldPath.documentID(), in: favoritesList).getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else { completion(error, nil); return }
                let products: [Product] = snapshot.documents.map { document in
                    Product.parseDataFromFirebase(document: document)
                }
                completion(nil, products.sorted(by: { product1, product2 in
                    guard let firstDate = product1.date, let secondDate = product2.date else { return false }
                    return firstDate.compare(secondDate) == .orderedDescending
                }))
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

    func addToFavorites(productUuid: String, userUuid: String, completion: @escaping (Error?) -> ()) {
        db.collection(USERS_COLLECTION_KEY).document(userUuid).setData(["favorites": FieldValue.arrayUnion([productUuid])], merge: true) { error in
            if error == nil { self.userFavorites.append(productUuid) }
            completion(error)
        }
    }

    func removeFromFavorites(productUuid: String, userUuid: String, completion: @escaping (Error?) -> ()) {
        db.collection(USERS_COLLECTION_KEY).document(userUuid).setData(["favorites": FieldValue.arrayRemove([productUuid])], merge: true) { error in
            if error == nil { self.userFavorites.removeAll { uuid in uuid == productUuid }}
            completion(error)
        }
    }

    func getUserFavoritesList(userUuid: String, completion: @escaping ([String]?) -> ()) {
        db.collection(USERS_COLLECTION_KEY).document(userUuid).getDocument { document, _ in
            completion(document?.data()?["favorites"] as? [String])
        }
    }

    func getUserFavorites() -> [String] {
        return userFavorites
    }

    func getUserTransactions(userUuid: String, completion: @escaping (Error?, [Transaction]?) -> ()) {
        var transactions = [Transaction]()
        db.collection(TRANSACTIONS_COLLECTION_KEY).whereField("buyerUuid", isEqualTo: userUuid).getDocuments { buyerSnapshot, buyerError in
            guard let buyerSnapshot = buyerSnapshot, buyerError == nil else { completion(buyerError, nil); return }
            self.db.collection(TRANSACTIONS_COLLECTION_KEY).whereField("sellerUuid", isEqualTo: userUuid).getDocuments { sellerSnapshot, sellerError in
                guard let sellerSnapshot = sellerSnapshot, sellerError == nil else { completion(sellerError, nil); return }
                transactions.append(contentsOf: buyerSnapshot.documents.map { document in
                    Transaction.parseDataFromFirebase(document: document, userUuid: userUuid)
                })
                transactions.append(contentsOf: sellerSnapshot.documents.map { document in
                    Transaction.parseDataFromFirebase(document: document, userUuid: userUuid)
                })
                completion(nil, transactions.sorted(by: { transaction1, transaction2 in
                    guard let firstDate = transaction1.date, let secondDate = transaction2.date else { return false }
                    return firstDate.compare(secondDate) == .orderedDescending
                }))
            }
        }
    }
}
