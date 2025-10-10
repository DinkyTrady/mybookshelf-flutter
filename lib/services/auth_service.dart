import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_flut/models/users/user_account.dart';

class AuthResult {
  final bool success;
  final String message;
  final UserAccount? user;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<AuthResult> signIn(String email, String password) async {
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
        return AuthResult(
          success: true,
          message: 'Successfully signed in',
          user: UserAccount.fromMap(userDoc.data() as Map<String, dynamic>),
        );
      }
      return AuthResult(
        success: false,
        message: 'User account not found',
      );
    } catch (e) {
      print('Error occurred: $e'); // logging some error
      String errorMessage = 'Authentication failed';
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password';
            break;
          case 'invalid-email':
            errorMessage = 'Email address is not valid';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled';
            break;
        }
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    }
  }

  Future<AuthResult> signUp(
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
        return AuthResult(
          success: false,
          message: 'Failed to create user account',
        );
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
      return AuthResult(
        success: true,
        message: 'Account created successfully',
        user: userAccount,
      );
    } catch (e) {
      print('Registration error: $e'); // logging some error
      String errorMessage = 'Registration failed';
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'Email is already in use';
            break;
          case 'invalid-email':
            errorMessage = 'Email address is not valid';
            break;
          case 'weak-password':
            errorMessage = 'Password is too weak';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Account creation is not enabled';
            break;
        }
      }
      
      return AuthResult(
        success: false,
        message: errorMessage,
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
