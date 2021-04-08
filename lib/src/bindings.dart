import 'dart:ffi' as ffi;
import 'package:linux_can/src/bindings/libc_arm32.g.dart';

typedef _c_ioctl_pointer_32 = ffi.Int32 Function(
    ffi.Int32 __fd, ffi.Uint32 __request, ffi.Pointer<ffi.Void> argp);

typedef _c_ioctl_pointer_64 = ffi.Int32 Function(
    ffi.Int32 __fd, ffi.Uint64 __request, ffi.Pointer<ffi.Void> argp);

typedef _dart_ioctl_pointer = int Function(
    int __fd, int __request, ffi.Pointer<ffi.Void> argp);

/// Base which constructs all methods needed. Helpful to provide one functionset
/// for all Platforms.
abstract class LibCBase {
  int ioctl(int __fd, int __request);
  int ioctlPointer(int __fd, int __request, ffi.Pointer argp);
  int socket(int __domain, int __type, int __protocol);
  int getsockname(
    int __fd,
    ffi.Pointer<sockaddr> __addr,
    ffi.Pointer<ffi.Uint32> __len,
  );
  int bind(int __fd, ffi.Pointer<sockaddr> __addr, int __len);
  int read(int __fd, ffi.Pointer<ffi.Void> __buf, int __nbytes);
  int write(int __fd, ffi.Pointer<ffi.Void> __buf, int __n);
  int close(int __fd);
}

/// Implementation of the Arm32 C Library.
class LibC32 extends LibCArm32 implements LibCBase {
  LibC32(this._dylib) : super(_dylib);

  final ffi.DynamicLibrary _dylib;

  late final _dart_ioctl_pointer _ioctlPointer =
      _dylib.lookupFunction<_c_ioctl_pointer_32, _dart_ioctl_pointer>('ioctl');

  @override
  int ioctlPointer(int __fd, int __request, ffi.Pointer argp) {
    return _ioctlPointer(__fd, __request, argp.cast<ffi.Void>());
  }
}

/// Implementation of the Arm64 C Library.
class LibC64 extends LibCArm32 implements LibCBase {
  LibC64(this._dylib) : super(_dylib);

  final ffi.DynamicLibrary _dylib;

  late final _dart_ioctl_pointer _ioctlPointer =
      _dylib.lookupFunction<_c_ioctl_pointer_64, _dart_ioctl_pointer>('ioctl');

  @override
  int ioctlPointer(int __fd, int __request, ffi.Pointer argp) {
    return _ioctlPointer(__fd, __request, argp.cast<ffi.Void>());
  }
}

/// Final interface to call C functions.
class LibC implements LibCBase {
  factory LibC(ffi.DynamicLibrary dylib) {
    LibCBase _native;

    if (ffi.sizeOf<ffi.Pointer>() == 8) {
      _native = LibC64(dylib);
    } else {
      _native = LibC32(dylib);
    }
    return LibC._internal(dylib, _native);
  }

  LibC._internal(this._dylib, this._native);

  // ignore: unused_field
  final ffi.DynamicLibrary _dylib;
  final LibCBase _native;

  @override
  int bind(int __fd, ffi.Pointer<sockaddr> __addr, int __len) {
    return _native.bind(__fd, __addr, __len);
  }

  @override
  int close(int __fd) => _native.close(__fd);

  @override
  int getsockname(
      int __fd, ffi.Pointer<sockaddr> __addr, ffi.Pointer<ffi.Uint32> __len) {
    return _native.getsockname(__fd, __addr, __len);
  }

  @override
  int ioctl(int __fd, int __request) {
    return _native.ioctl(__fd, __request);
  }

  @override
  int ioctlPointer(int __fd, int __request, ffi.Pointer<ffi.NativeType> argp) {
    return _native.ioctlPointer(__fd, __request, argp);
  }

  @override
  int read(int __fd, ffi.Pointer<ffi.Void> __buf, int __nbytes) {
    return _native.read(__fd, __buf, __nbytes);
  }

  @override
  int socket(int __domain, int __type, int __protocol) {
    return _native.socket(__domain, __type, __protocol);
  }

  @override
  int write(int __fd, ffi.Pointer<ffi.Void> __buf, int __n) {
    return _native.write(__fd, __buf, __n);
  }
}
