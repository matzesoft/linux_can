import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:linux_can/src/bindings.dart';
import 'package:linux_can/src/bindings/custom_bindings.dart';

import 'bindings/libc_arm32.g.dart';

const _dylib = "libc.so.6";
const _canInterface = "can0";
const _canInterfaceUtf8 = [
  0x63, //c
  0x61, //a
  0x6E, //n
  0x30, //0
];

class CanDevice {
  final _library = DynamicLibrary.open(_dylib);
  late final _libC = LibC(_library);

  CanDevice({int bitrate: 500000}) {
    final cmd = 'sudo ip link set $_canInterface up type can bitrate $bitrate';
    _libC.system(cmd.toNativeUtf8());
  }

  int _socket = -1;

  /// Sets up the socket and binds it to `can0`. Throws an `SocketException``
  /// when something wents wrong.
  void setup() {
    _socket = _libC.socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (_socket < 0) throw SocketException("Failed to open CAN socket.");

    final ifrPtr = malloc.allocate<ifreq>(sizeOf<ifreq>());
    final ifr = ifrPtr.ref;
    ifr.ifr_name[0] = _canInterfaceUtf8[0];
    ifr.ifr_name[1] = _canInterfaceUtf8[1];
    ifr.ifr_name[2] = _canInterfaceUtf8[2];
    ifr.ifr_name[3] = _canInterfaceUtf8[3];
    final outputioctl = _libC.ioctlPointer(_socket, SIOCGIFINDEX, ifrPtr);
    if (outputioctl < 0)
      throw SocketException("Failed to initalize CAN socket: $_socket");

    final addrCanPtr =
        malloc.allocate<sockaddr_can>(sizeOf<sockaddr_can>());
    final addrCan = addrCanPtr.ref;
    addrCan.can_family = AF_CAN;
    addrCan.can_ifindex = ifr.ifr_ifindex;

    final len = sizeOf<sockaddr>();
    final sockaddrPtr = addrCanPtr.cast<sockaddr>();
    final output = _libC.bind(_socket, sockaddrPtr, len);
    if (output < 0)
      throw SocketException("Failed to bind CAN socket: $_socket");

    malloc.free(ifrPtr);
    malloc.free(addrCanPtr);
  }

  /// Reads from the CAN bus. Throws an `SocketException` when failed.
  CanFrame read() {
    if (_socket < 0) throw StateError("Call setup() before reading.");

    final canFrame = malloc.allocate<can_frame>(sizeOf<can_frame>());
    final pointer = canFrame.cast<Void>();
    final len = sizeOf<can_frame>();
    if (_libC.read(_socket, pointer, len) < 0)
      throw SocketException("Failed to read from CAN Socket: $_socket");

    final resultFrame = pointer.cast<can_frame>().ref;
    final read = CanFrame._fromNative(resultFrame);

    malloc.free(canFrame);
    return read;
  }

  void close() {
    _libC.close(_socket);
    _socket = -1;
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
