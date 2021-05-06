import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:linux_can/src/bindings.dart';
import 'package:linux_can/src/bindings/custom_bindings.dart';

import 'bindings/libc_arm32.g.dart';

const _DYLIB = "libc.so.6";
const _CAN_INTERFACE = "can0";
const _CAN_INTERFACE_UTF8 = [
  0x63, //c
  0x61, //a
  0x6E, //n
  0x30, //0
];

void _setupBitrate(int bitrate) {
  final _libC = LibC(DynamicLibrary.open(_DYLIB));

  final cmd = 'sudo ip link set $_CAN_INTERFACE up type can bitrate $bitrate';
  _libC.system(cmd.toNativeUtf8());
}

class CanDevice {
  late final _libC = LibC(DynamicLibrary.open(_DYLIB));

  CanDevice({int bitrate: 500000}) {
    final isolate = Isolate.spawn<int>(_setupBitrate, bitrate);
    isolate.then((value) => value.kill());
  }

  int _socket = -1;

  /// Sets up the socket and binds it to `can0`. Throws an `SocketException``
  /// when something wents wrong.
  void setup() {
    _socket = _libC.socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (_socket < 0) throw SocketException("Failed to open CAN socket.");

    // Set socket non-blocking
    final flags = _libC.fcntl(_socket, F_GETFL, 0);
    _libC.fcntl(_socket, F_SETFL, flags | O_NONBLOCK);

    // IFR
    final ifrPtr = malloc.allocate<ifreq>(sizeOf<ifreq>());
    final ifr = ifrPtr.ref;
    ifr.ifr_name[0] = _CAN_INTERFACE_UTF8[0];
    ifr.ifr_name[1] = _CAN_INTERFACE_UTF8[1];
    ifr.ifr_name[2] = _CAN_INTERFACE_UTF8[2];
    ifr.ifr_name[3] = _CAN_INTERFACE_UTF8[3];
    final outputioctl = _libC.ioctlPointer(_socket, SIOCGIFINDEX, ifrPtr);
    if (outputioctl < 0)
      throw SocketException("Failed to initalize CAN socket: $_socket");

    // CAN Addr
    final addrCanPtr = malloc.allocate<sockaddr_can>(sizeOf<sockaddr_can>());
    final addrCan = addrCanPtr.ref;
    addrCan.can_family = AF_CAN;
    addrCan.can_ifindex = ifr.ifr_ifindex;

    // Bind socket
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
