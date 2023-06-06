import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skin_scan_app/services/cloud/cloud_note.dart';
import 'package:skin_scan_app/services/cloud/cloud_job.dart';
import 'package:skin_scan_app/services/cloud/cloud_storage_constants.dart';
import 'package:skin_scan_app/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  final jobs = FirebaseFirestore.instance.collection('jobs');

// notes
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String jobName,
    required String roomName,
    required String roomArea,
    required String roomHeight,
    required String openingArea,
    required String typicalWindSpeed,
    required String result,
  }) async {
    try {
      await notes.doc(documentId).update({
        jobNameField: jobName,
        roomNameField: roomName,
        roomAreaField: roomArea,
        roomHeightField: roomHeight,
        openingAreaField: openingArea,
        typicalWindSpeedField: typicalWindSpeed,
        resultField: result,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    print('allnotes');
    final allNotes = notes
        .where(ownerUserIdField, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdField: ownerUserId,
      jobNameField: '',
      roomNameField: '',
      roomAreaField: '',
      roomHeightField: '',
      openingAreaField: '',
      typicalWindSpeedField: '',
      resultField: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      jobName: '',
      roomName: '',
      roomArea: '',
      roomHeight: '',
      openingArea: '',
      typicalWindSpeed: '',
      result: '',
    );
  }

// jobs
  Future<void> deleteJob({required String documentId}) async {
    try {
      await jobs.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteJobException();
    }
  }

  Future<void> updateJob({
    required String documentId,
    required String jobName,
    required String jobType,
    required String jobSubType,
  }) async {
    try {
      await jobs.doc(documentId).update({
        jobNameField: jobName,
        jobTypeField: jobType,
        jobSubTypeField: jobSubType,
      });
    } catch (e) {
      print(e);
      print('HEREEEE!!!XXXXX');
      throw CouldNotUpdateJobException();
    }
  }

  Stream<Iterable<CloudJob>> allJobs({required String ownerUserId}) {
    print('alljobs');
    final allJobs = jobs
        .where(ownerUserIdField, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudJob.fromSnapshot(doc)));
    return allJobs;
  }

  Future<CloudJob> createNewJob({required String ownerUserId}) async {
    final document = await jobs.add({
      ownerUserIdField: ownerUserId,
      jobNameField: '',
      jobTypeField: '',
      jobSubTypeField: '',
    });
    final fetchedJob = await document.get();
    return CloudJob(
      documentId: fetchedJob.id,
      ownerUserId: ownerUserId,
      jobName: '',
      jobType: '',
      jobSubType: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
