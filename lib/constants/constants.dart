import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  Constants._private();
  static const usersCollection = "users";
  static final user = FirebaseAuth.instance.currentUser!;
  static final currentUser = FirebaseAuth.instance.currentUser;
  static const locationsCollection = "location";

  static const hotelsCollection = "hotels";
  static const cartCollection = "cart";
  static final cartRef =
      FirebaseFirestore.instance.collection("users").doc(user.uid.toString());
  static final orderRef =
      FirebaseFirestore.instance.collection("users").doc(user.uid.toString());

  static const orderCollection = "orders";

  static const paymentsCollection = "payments";

  static final favoriteRef = FirebaseFirestore.instance
      .collection("favorite")
      .doc(user.uid.toString());
  static const defaultAmount = 0;
  static String moneyUnit = '₫';
  static String dayFormat = 'd MMM, yyyy (EEE)';
  static String monthFormat = 'MMMM, yyyy';
}
