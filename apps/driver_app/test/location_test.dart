import 'dart:async';

import 'package:driver_app/src/location/location_buffer.dart';
import 'package:driver_app/src/location/location_reporter.dart';
import 'package:driver_app/src/location/tracked_point.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

TrackedPoint _at(DateTime t) => TrackedPoint(latitude: 5.7, longitude: 0.1, recordedAt: t);

void main() {
  group('LocationBuffer', () {
    test('drops points older than ten minutes, keeps the rest in order', () {
      var now = DateTime.utc(2026, 1, 1, 12);
      final buffer = LocationBuffer(now: () => now);
      buffer.add(_at(now.subtract(const Duration(minutes: 11))));
      buffer.add(_at(now.subtract(const Duration(minutes: 9))));
      buffer.add(_at(now));
      expect(buffer.dropStale(), 1);
      expect(buffer.length, 2);
      expect(buffer.peekBatch().first.recordedAt, now.subtract(const Duration(minutes: 9)));
    });

    test('a batch is at most 20 points and is only removed once sent', () {
      final now = DateTime.utc(2026, 1, 1);
      final buffer = LocationBuffer(now: () => now);
      for (var i = 0; i < 45; i++) {
        buffer.add(_at(now.add(Duration(seconds: i))));
      }
      expect(buffer.peekBatch(), hasLength(20));
      expect(buffer.length, 45);
      buffer.removeFirst(20);
      expect(buffer.length, 25);
    });
  });

  group('LocationReporter', () {
    late StreamController<TrackedPoint> source;
    late List<List<TrackedPoint>> sent;
    bool offline = false;

    setUp(() {
      source = StreamController<TrackedPoint>();
      sent = [];
      offline = false;
    });

    LocationReporter make(FakeAsync async) => LocationReporter(
          source: source.stream,
          now: () => async.getClock(DateTime.utc(2026, 1, 1)).now(),
          send: (points) async {
            if (offline) throw Exception('offline');
            sent.add(points);
          },
        );

    test('sends one point every five seconds, not more', () {
      fakeAsync((async) {
        final reporter = make(async)..start();
        final base = async.getClock(DateTime.utc(2026, 1, 1)).now();
        // A fix every second for 12 seconds.
        for (var s = 0; s < 12; s++) {
          source.add(_at(base.add(Duration(seconds: s))));
          async.elapse(const Duration(seconds: 1));
        }
        expect(sent.map((b) => b.length), everyElement(1));
        expect(sent.length, 3, reason: 'at 0s, 5s and 10s');
        reporter.dispose();
      });
    });

    test('buffers while offline and flushes in order on reconnect', () {
      fakeAsync((async) {
        final reporter = make(async)..start();
        final base = async.getClock(DateTime.utc(2026, 1, 1)).now();
        offline = true;
        for (var s = 0; s < 30; s += 5) {
          source.add(_at(base.add(Duration(seconds: s))));
          async.elapse(const Duration(seconds: 5));
        }
        expect(sent, isEmpty);
        expect(reporter.state.value.buffered, 6);
        expect(reporter.state.value.failures, greaterThan(0));

        offline = false;
        async.elapse(const Duration(seconds: 5));
        expect(sent, hasLength(1));
        expect(sent.single, hasLength(6));
        final times = sent.single.map((p) => p.recordedAt).toList();
        expect(times, orderedEquals([...times]..sort()));
        expect(reporter.state.value.buffered, 0);
        expect(reporter.state.value.lastError, isNull);
        reporter.dispose();
      });
    });

    test('splits a long backlog into requests of 20', () {
      fakeAsync((async) {
        final reporter = make(async)..start();
        final base = async.getClock(DateTime.utc(2026, 1, 1)).now();
        offline = true;
        for (var i = 0; i < 45; i++) {
          source.add(_at(base.add(Duration(seconds: i * 5))));
          async.elapse(const Duration(milliseconds: 100));
        }
        // Points are 5 s apart by timestamp; the clock moved only 4.5 s, so
        // none are stale yet.
        offline = false;
        async.elapse(const Duration(seconds: 5));
        expect(sent.map((b) => b.length), [20, 20, 5]);
        reporter.dispose();
      });
    });

    test('points older than ten minutes are dropped, not sent', () {
      fakeAsync((async) {
        final reporter = make(async)..start();
        final base = async.getClock(DateTime.utc(2026, 1, 1)).now();
        offline = true;
        source.add(_at(base));
        async.elapse(const Duration(minutes: 11));
        offline = false;
        async.elapse(const Duration(seconds: 5));
        expect(sent, isEmpty);
        expect(reporter.state.value.pointsDropped, 1);
        reporter.dispose();
      });
    });

    test('detects its own stall: silent GPS and unreachable server', () {
      fakeAsync((async) {
        final reporter = make(async)..start();
        final start = async.getClock(DateTime.utc(2026, 1, 1)).now();
        const limit = Duration(seconds: 30);
        expect(reporter.state.value.gpsSilent(start, limit), isFalse);
        async.elapse(const Duration(seconds: 40));
        final now = start.add(const Duration(seconds: 40));
        expect(reporter.state.value.gpsSilent(now, limit), isTrue);
        expect(reporter.state.value.serverUnreachable(now, limit), isTrue);
        reporter.dispose();
      });
    });

    test('stop ends reporting', () {
      fakeAsync((async) {
        final reporter = make(async)..start();
        reporter.stop();
        async.flushMicrotasks();
        final base = async.getClock(DateTime.utc(2026, 1, 1)).now();
        source.add(_at(base));
        async.elapse(const Duration(seconds: 10));
        expect(sent, isEmpty);
        expect(reporter.state.value.running, isFalse);
        reporter.dispose();
      });
    });
  });
}
