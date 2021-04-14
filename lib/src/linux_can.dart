import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;
import 'package:linux_can/src/bindings.dart';
import 'package:linux_can/src/bindings/custom_bindings.dart';

import 'bindings/libc_arm32.g.dart';

const _dylib = "libc.so.6";
const _canInterface = [
  0x63, //c
  0x61, //a
  0x6E, //n
  0x30, //0
];

class CanDevice {
  final _library = ffi.DynamicLibrary.open(_dylib);
  late final _backend = LibC(_library);

  int _socket = -1;

  void setup() {
    _socket = _backend.socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (_socket < 0) throw StateError("Failed to initalize CAN socket.");

    final ifrPtr = ffi.allocate<ifreq>();
    final ifr = ifrPtr.ref;
    ifr.ifr_name[0] = _canInterface[0];
    ifr.ifr_name[1] = _canInterface[1];
    ifr.ifr_name[2] = _canInterface[2];
    ifr.ifr_name[3] = _canInterface[3];
    final outputioctl = _backend.ioctlPointer(_socket, SIOCGIFINDEX, ifrPtr);
    if (outputioctl < 0) throw StateError("Failed to initalize CAN socket.");

    final addrCanPtr = ffi.allocate<sockaddr_can>();
    final addrCan = addrCanPtr.ref;
    addrCan.can_family = AF_CAN;
    addrCan.can_ifindex = ifr.ifr_ifindex;

    final len = ffi.sizeOf<sockaddr>();
    final sockaddrPtr = addrCanPtr.cast<sockaddr>();
    final output = _backend.bind(_socket, sockaddrPtr, len);
    if (output < 0) throw StateError("Failed to bind CAN socket.");

    ffi.free(ifrPtr);
    ffi.free(addrCanPtr);
  }

  CanFrame read() {
    if (_socket < 0) throw StateError("Call setup() before reading.");

    final canFrame = ffi.allocate<can_frame>();
    final pointer = canFrame.cast<ffi.Void>();
    final len = ffi.sizeOf<can_frame>();
    if (_backend.read(_socket, pointer, len) < 0)
      throw Exception("Failed to read from CanDevice");

    final resultFrame = pointer.cast<can_frame>().ref;
    final read = CanFrame._fromNative(resultFrame);

    ffi.free(canFrame);
    return read;
  }
}

class CanFrame {
  int? id;
  List<int> data = [];

  CanFrame._fromNative(can_frame frame) {
    id = frame.can_id;
    final results = frame.data;
    for (int i = 0; i < results.length; i++) {
      data.add(results[i]);
    }
  }
}
