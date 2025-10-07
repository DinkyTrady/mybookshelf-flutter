import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_flut/models/users/user_account.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserAccount?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _fireStore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        return UserAccount.fromMap(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error ocured: $e'); // logging some error
      return null;
    }
  }

  Future<bool> signUp(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user?.uid;
      if (uid == null) {
        return false;
      }

      final userAccount = UserAccount(
        id: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        biography: '', // Default empty biography
      );
      await _fireStore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userAccount.toMap())
          .catchError((e) {
            print('Firestore write error: $e');
          });
      return true;
    } catch (e) {
      print('register error: $e'); // logging some error
      return false;
    }
  }
}
