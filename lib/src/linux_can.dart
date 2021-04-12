import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:linux_can/src/bindings.dart';
import 'package:linux_can/src/bindings/custom_bindings.dart';

import 'bindings/libc_arm32.g.dart';

const String _dylib = "libc.so.6";
const String _canInterface = "can0";

class CanDevice {
  final _library = ffi.DynamicLibrary.open(_dylib);
  late final _backend = LibC(_library);

  int _socket = -1;

  void setup() {
    print("Setup CanDevice");
    _socket = _backend.socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (_socket < 0) throw Exception("Failed to initalize CAN socket.");
    print("Socket: $_socket");

    final ifreq ifr = ifreq();
    ifr.ifr_name = Utf8.toUtf8(_canInterface);
    final ioctlOutput =
        _backend.ioctlPointer(_socket, SIOCGIFINDEX, ifr.addressOf);
    print("ioctlPointer: $ioctlOutput");

    final sockaddr_can addr = sockaddr_can();
    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    final addrPointer = addr.addressOf.cast<sockaddr>();
    final len = ffi.sizeOf<sockaddr>();
    if (_backend.bind(_socket, addrPointer, len) < 0)
      throw Exception("Failed to bind CAN socket.");
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
