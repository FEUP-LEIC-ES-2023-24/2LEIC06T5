import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/controller/queries.dart';


void processSwipeRight(Book book) async {
  String? ownerEmail = book.ownerEmail;
  DocumentSnapshot currentUser = await Queries.getCurrentUser();
    
}