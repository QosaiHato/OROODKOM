import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { normal, business, admin }

enum VerificationStatus { pending, approved, rejected }

class User {
  final String email;
  final String photoUrl;
  final String businessProofUrl;
  final String uid;
  final String username;
  final String bio;
  final UserType userType;
  final String? businessName;
  final String? phoneNumber;
  final String? whatsappNumber;
  final VerificationStatus verificationStatus;

  User({
    required this.email,
    required this.photoUrl,
    required this.businessProofUrl,
    required this.uid,
    required this.username,
    required this.bio,
    required this.userType,
    this.businessName,
    this.phoneNumber,
    this.whatsappNumber,
    required this.verificationStatus,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'photoUrl': photoUrl,
        'businessProofUrl': businessProofUrl,
        'uid': uid,
        'username': username,
        'bio': bio,
        'userType': userType.toString().split('.').last,
        'businessName': businessName,
        'phoneNumber': phoneNumber,
        'whatsappNumber': whatsappNumber,
        'verificationStatus': verificationStatus.toString().split('.').last,
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>?;
    if (snapshot == null) {
      return User(
        email: '',
        photoUrl: '',
        businessProofUrl: '',
        uid: '',
        username: '',
        bio: '',
        userType: UserType.normal,
        verificationStatus: VerificationStatus.pending,
      );
    }
    return User(
      email: snapshot['email'] as String? ?? '',
      photoUrl: snapshot['photoUrl'] as String? ?? '',
      businessProofUrl: snapshot['businessProofUrl'] as String? ?? '',
      uid: snapshot['uid'] as String? ?? '',
      username: snapshot['username'] as String? ?? '',
      bio: snapshot['bio'] as String? ?? '',
      userType: snapshot['userType'] != null
          ? UserType.values.firstWhere(
              (type) => type.toString() == 'UserType.${snapshot['userType']}',
              orElse: () => UserType.normal,
            )
          : UserType.normal,
      businessName: snapshot['businessName'] as String?,
      phoneNumber: snapshot['phoneNumber'] as String?,
      whatsappNumber: snapshot['whatsappNumber'] as String?,
      verificationStatus: snapshot['verificationStatus'] != null
          ? VerificationStatus.values.firstWhere(
              (status) =>
                  status.toString() ==
                  'VerificationStatus.${snapshot['verificationStatus']}',
              orElse: () => VerificationStatus.pending,
            )
          : VerificationStatus.pending,
    );
  }
}
