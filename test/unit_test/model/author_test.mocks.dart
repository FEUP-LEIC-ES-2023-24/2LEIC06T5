// Mocks generated by Mockito 5.4.4 from annotations
// in pagepal/test/unit_test/model/author_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i3;
import 'package:pagepal/model/book.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [Book].
///
/// See the documentation for Mockito's code generation for more information.
class MockBook extends _i1.Mock implements _i2.Book {
  @override
  List<String> get authors => (super.noSuchMethod(
        Invocation.getter(#authors),
        returnValue: <String>[],
        returnValueForMissingStub: <String>[],
      ) as List<String>);

  @override
  List<String> get genres => (super.noSuchMethod(
        Invocation.getter(#genres),
        returnValue: <String>[],
        returnValueForMissingStub: <String>[],
      ) as List<String>);

  @override
  String get isbn => (super.noSuchMethod(
        Invocation.getter(#isbn),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.getter(#isbn),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.getter(#isbn),
        ),
      ) as String);

  @override
  String get lang => (super.noSuchMethod(
        Invocation.getter(#lang),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.getter(#lang),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.getter(#lang),
        ),
      ) as String);

  @override
  int get pubYear => (super.noSuchMethod(
        Invocation.getter(#pubYear),
        returnValue: 0,
        returnValueForMissingStub: 0,
      ) as int);

  @override
  String get title => (super.noSuchMethod(
        Invocation.getter(#title),
        returnValue: _i3.dummyValue<String>(
          this,
          Invocation.getter(#title),
        ),
        returnValueForMissingStub: _i3.dummyValue<String>(
          this,
          Invocation.getter(#title),
        ),
      ) as String);
}