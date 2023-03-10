import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_pagination_method_channel.dart';

abstract class FlutterPaginationPlatform extends PlatformInterface {
  /// Constructs a FlutterPaginationPlatform.
  FlutterPaginationPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPaginationPlatform _instance = MethodChannelFlutterPagination();

  /// The default instance of [FlutterPaginationPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPagination].
  static FlutterPaginationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPaginationPlatform] when
  /// they register themselves.
  static set instance(FlutterPaginationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
