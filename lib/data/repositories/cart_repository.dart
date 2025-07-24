import 'package:chandoiqua/data/models/room_in_hotel.dart';
import 'package:chandoiqua/data/repositories/abstract_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../constants/constants.dart';
import '../../core/failure.dart';
import '../models/cart_item.dart';

class CartRepository implements CartInterface {
  CartRepository(
      {required FirebaseFirestore firebaseFireStore,
      required FirebaseAuth firebaseAuth,
      required FirebaseStorage firebaseStorage,
      required Ref ref});
  @override
  Either<dynamic, Future<void>> addProductToCart(
      Room hotel, BuildContext context) {
    String cartId = const Uuid().v1();
    try {
      return right(Constants.cartRef.set({
        "cart": FieldValue.arrayUnion([
          CartItem(
            cartId: cartId,
            image: hotel.image.toString(),
            // productId: hotel.hotelId.toString(),
            quantity: 1,
            cost: hotel.oldPrice!.toDouble(),
            name: hotel.name!,
            price: hotel.oldPrice!,
            numberOfBeds: hotel.numberOfBeds.toString(),
            area: hotel.area.toString(),
            view: hotel.view.toString(),
            regulations: hotel.regulations.toString(),
          ).toJson()
        ]),
      }, SetOptions(merge: true)));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Either<dynamic, Future<void>> removeCartItem(CartItem cartItem) {
    try {
      return right(Constants.cartRef.update({
        "cart": FieldValue.arrayRemove([cartItem.toJson()])
      }));
    } catch (e) {
      return left(throw Exception(e));
    }
  }

  @override
  Future<void> clearCart() async {
    Constants.cartRef.update({"cart": FieldValue.delete()});
  }

  @override
  void decreaseQuantity(CartItem item) {
    if (item.quantity == 1) {
      removeCartItem(item);
    } else {
      item.quantity - 1;
      Constants.cartRef.update({
        "cart": FieldValue.arrayRemove([item.toJson()])
      });
    }
  }
// void increaseQuantity(CartItem item) {
//   // removeCartItem(item);
//   FirebaseConstants.cartRef.get().then((DocumentSnapshot doc) {
//     final dynamic data = doc.data() as Map<String, dynamic>;
//     _firestore.runTransaction((transaction) async {
//       final snapshot = await transaction.get(FirebaseConstants.cartRef);
//       final newQuantity = snapshot.get(data!["cart"]) + 1;
//     }).then((quantity) => print("error increasing quantity"),
//         onError: (e) => print("Error updating document $e"));
//   });
// }
}
