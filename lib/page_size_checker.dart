// lib/page_size_checker.dart
import 'dart:ffi';
import 'dart:io' show Platform;

typedef _GetPageSizeNative = Int32 Function();
typedef _GetPageSize = int Function();

int getOsPageSize() {
  final DynamicLibrary lib = Platform.isAndroid ? DynamicLibrary.open('libc.so') : DynamicLibrary.process();

  try {
    final _GetPageSize getpagesize = lib.lookupFunction<_GetPageSizeNative, _GetPageSize>('getpagesize');
    return getpagesize();
  } catch (_) {
    const int SC_PAGESIZE = 30;

    final int Function(int p1) sysconf = lib.lookupFunction<IntPtr Function(Int32), int Function(int)>('sysconf');
    return sysconf(SC_PAGESIZE);
  }
}
