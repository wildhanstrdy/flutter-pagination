import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/flutter_pagination_platform_interface.dart';
import 'package:flutter_pagination/flutter_pagination_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPaginationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPaginationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPaginationPlatform initialPlatform = FlutterPaginationPlatform.instance;

  test('$MethodChannelFlutterPagination is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPagination>());
  });

  test('getPlatformVersion', () async {
    FlutterPagination flutterPaginationPlugin = FlutterPagination();
    MockFlutterPaginationPlatform fakePlatform = MockFlutterPaginationPlatform();
    FlutterPaginationPlatform.instance = fakePlatform;

    expect(await flutterPaginationPlugin.getPlatformVersion(), '42');
  });
}
