import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireproof/fireproof.dart';
import 'package:fireproof_riverpod/src/models/base_query_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kt_dart/kt.dart';

import 'base_handler.dart';

class QueryHandler<T> extends BaseQueryHandler<T, Query<T>> {
  QueryHandler({
    required Query<T> query,
    TestDoc<T> testDoc = BaseHandler.defaultTest,
  }) : super(
          query: query,
          testDoc: testDoc,
        );

  /// Forces a fetch of all the documents and returns a corresponding snapshot
  /// with the id `id`.
  @override
  late final AutoDisposeFutureProviderFamily<Doc<T>, String> docSnapshot =
      FutureProvider.autoDispose.family<Doc<T>, String>(
    (ref, id) async {
      final querySnapshot = await ref.watch(snapshot.future);

      return querySnapshot.docs.singleWhere((doc) => doc.id == id);
    },
  );

  @override
  late final AutoDisposeStreamProviderFamily<Doc<T>, String> docSnapshots =
      StreamProvider.autoDispose.family<Doc<T>, String>(
    (ref, id) async* {
      await for (final querySnapshot in ref.watch(snapshots.stream)) {
        yield querySnapshot.docs.singleWhere((doc) => doc.id == id);
      }
    },
  );

  @override
  late final docsInSnapshot =
      FutureProvider.autoDispose.family<Iterable<Doc<T>>, KtList<String>>(
    (ref, ids) async {
      throw UnimplementedError();
      // final querySnapshot = await ref.watch(snapshot.future);

      // querySnapshot.docs.singleWhere((doc) => doc.id == id);
    },
  );

  @override
  late final docsInSnapshots =
      StreamProvider.autoDispose.family<Iterable<Doc<T>>, KtList<String>>(
    (ref, ids) async* {
      throw UnimplementedError();
      // await for (final querySnapshot in ref.watch(snapshots.stream)) {
      //   yield querySnapshot.docs.singleWhere((doc) => doc.id == id);
      // }
    },
  );
}
