import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internapp/services/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(
    String name,
    String email,
    String phoneNo,
  ) async {
    return await usersCollection.document(uid).setData(
        {'uid': uid, 'name': name, 'email': email, 'phoneNo': phoneNo});
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      email: snapshot.data['email'] ?? '',
      phoneNo: snapshot.data['phoneNo'] ?? '',
    );
  }

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
