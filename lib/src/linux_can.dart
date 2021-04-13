import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;
import 'package:linux_can/src/bindings.dart';
import 'package:linux_can/src/bindings/custom_bindings.dart';

import 'bindings/libc_arm32.g.dart';

const _dylib = "libc.so.6";
const _canInterface = "can0";

class CanDevice {
  final _library = ffi.DynamicLibrary.open(_dylib);
  late final _backend = LibC(_library);

  int _socket = -1;

  void setup() {
    _socket = _backend.socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (_socket < 0) throw StateError("Failed to initalize CAN socket.");

    final ifrPtr = ffi.allocate<ifreq>();
    final ifr = ifrPtr.ref;
    ifr.ifr_name = ffi.Utf8.toUtf8(_canInterface);
    print("Name: ${ifrPtr.ref.ifr_name.ref}");
    final outputioctl = _backend.ioctlPointer(_socket, SIOCGIFINDEX, ifrPtr);
    print("Output ioctl: $outputioctl");
    if (outputioctl < 0) throw StateError("Failed to initalize CAN socket.");

    final addrPtr = ffi.allocate<sockaddr_can>();
    final addr = addrPtr.ref;
    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    final len = ffi.sizeOf<sockaddr>();
    final sockaddrPtr = addrPtr.cast<sockaddr>();
    final output = _backend.bind(_socket, sockaddrPtr, len);
    print("Output: $output");
    if (output < 0) throw StateError("Failed to bind CAN socket.");

    print("Finished setup.");
  }

  int read() {
    if (_socket < 0) throw StateError("Setup CanDevice before reading.");

    final can_frame frame = can_frame();
    final pointer = frame.addressOf.cast<ffi.Void>();
    final len = ffi.sizeOf<can_frame>();
    final output = _backend.read(_socket, pointer, len);

    if (output < 0) throw Exception("Failed to read from CanDevice");
    return output;
  }
}
