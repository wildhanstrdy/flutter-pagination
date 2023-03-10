
import 'flutter_pagination_platform_interface.dart';

class FlutterPagination {
  Future<String?> getPlatformVersion() {
    return FlutterPaginationPlatform.instance.getPlatformVersion();
  }
}
