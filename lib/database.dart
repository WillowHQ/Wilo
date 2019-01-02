import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Counter {
  Counter({this.id, this.value});
  int id;
  int value;
}
class Reminder {
  Reminder({this.id, this.value});
  int id;
  int value;
  String prompt;
}

abstract class Database {
  Future<void> createCounter();
  Future<void> setCounter(Counter counter);
  Future<void> deleteCounter(Counter counter);
  Stream<List<Counter>> countersStream();

  Future<void> createReminder();
  Future<void> setReminder(Reminder reminder);
  Future<void> deleteReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder, String prompt);
  Stream<List<Reminder>> remindersStream();
}



// Cloud Firestore
class AppFirestore implements Database {

  Future<void> createCounter() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    Counter counter = Counter(id: now, value: 0);
    await setCounter(counter);
  }
  Future<void> setCounter(Counter counter) async {

    _documentReference(counter).setData({
      'value' : counter.value,
    });
  }

  Future<void> deleteCounter(Counter counter) async {
    _documentReference(counter).delete();
  }

  Stream<List<Counter>> countersStream() {
    return _FirestoreStream<List<Counter>>(
      apiPath: rootPath,
      parser: FirestoreCountersParser(),
    ).stream;
  }

  DocumentReference _documentReference(Counter counter) {
    return Firestore.instance.collection(rootPath).document('${counter.id}');
  }
 

  static final String rootPath = 'counters';

  //REMINDERS

  Future<void> createReminder() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    Reminder reminder = Reminder(id: now, value: 0);
    await setReminder(reminder);
  }
  Future<void> setReminder(Reminder reminder) async {

    _documentReminderReference(reminder).setData({
      'value' : reminder.value,
    });
  }

  Future<void> deleteReminder(Reminder reminder) async {
    _documentReminderReference(reminder).delete();
  }
  Future<void> updateReminder(Reminder reminder, String prompt) async {
    print("this got called database.data l 82");
    _documentReminderReference(reminder).setData({
      'prompt': prompt
    });
  }

  Stream<List<Reminder>> remindersStream() {
    return _FirestoreStream<List<Reminder>>(
      apiPath: reminderPath,
      parser: FirestoreRemindersParser(),
    ).stream;
  }

  DocumentReference _documentReminderReference(Reminder reminder) {
    return Firestore.instance.collection(reminderPath).document('${reminder.id}');
  }

  static final String reminderPath = 'reminders';
}

abstract class FirestoreNodeParser<T> {

  T parse(QuerySnapshot querySnapshot);
}

class FirestoreCountersParser extends FirestoreNodeParser<List<Counter>> {
  List<Counter> parse(QuerySnapshot querySnapshot) {
    var counters = querySnapshot.documents.map((documentSnapshot) {
      return Counter(
        id: int.parse(documentSnapshot.documentID),
        value: documentSnapshot['value'],
      );
    }).toList();
    counters.sort((lhs, rhs) => rhs.id.compareTo(lhs.id));
    return counters;
  }
}
class FirestoreRemindersParser extends FirestoreNodeParser<List<Reminder>> {
  List<Reminder> parse(QuerySnapshot querySnapshot) {
    var reminders = querySnapshot.documents.map((documentSnapshot) {
      return Reminder(
        id: int.parse(documentSnapshot.documentID),
        value: documentSnapshot['value'],
      );
    }).toList();
    reminders.sort((lhs, rhs) => rhs.id.compareTo(lhs.id));
    return reminders;
  }
}

class _FirestoreStream<T> {
  _FirestoreStream({String apiPath, FirestoreNodeParser<T> parser}) {
    CollectionReference collectionReference = Firestore.instance.collection(apiPath);
    Stream<QuerySnapshot> snapshots = collectionReference.snapshots();
    stream = snapshots.map((snapshot) => parser.parse(snapshot));
  }

  Stream<T> stream;
}
