// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi;

import 'libc_arm32.g.dart';

const SIOCGIFINDEX = 0x8933;

const F_GETFL = 0x03;
const F_SETFL = 0x04;

// Typedefs for custom `ioctl`-function.
typedef c_ioctl_pointer_32 = ffi.Int32 Function(
    ffi.Int32 __fd, ffi.Uint32 __request, ffi.Pointer<ffi.Void> argp);
typedef c_ioctl_pointer_64 = ffi.Int32 Function(
    ffi.Int32 __fd, ffi.Uint64 __request, ffi.Pointer<ffi.Void> argp);
typedef dart_ioctl_pointer = int Function(
    int __fd, int __request, ffi.Pointer<ffi.Void> argp);

// Typedefs for `system`-function.
typedef c_system = ffi.Int32 Function(ffi.Pointer<ffi.Utf8> command);
typedef dartSystem = int Function(ffi.Pointer<ffi.Utf8> command);

typedef c_fcntl = ffi.Int16 Function(
    ffi.Int16 fd, ffi.Int16 cmd, ffi.Int32 arg);
typedef dartFcntl = int Function(int fd, int cmd, int arg);

class epoll_event extends ffi.Struct {
  @ffi.Uint32()
  external int events;

  @ffi.Uint64()
  external int userdata;
}

/// struct sockaddr_can - the sockaddr structure for CAN sockets
/// @can_family:  address family number AF_CAN.
/// @can_ifindex: CAN network interface index.
/// @can_addr:    protocol specific address information
class sockaddr_can extends ffi.Struct {
  @ffi.Uint16()
  external int can_family;

  @ffi.Int16()
  external int can_ifindex;

  external tp_struct tp;
}

class tp_struct extends ffi.Struct {
  @ffi.Uint32()
  external int rx_id;

  @ffi.Uint32()
  external int tx_id;
}

class ifreq extends ffi.Struct {
  @ffi.Uint8()
  external int _unique_ifr_name_item_0;
  @ffi.Uint8()
  external int _unique_ifr_name_item_1;
  @ffi.Uint8()
  external int _unique_ifr_name_item_2;
  @ffi.Uint8()
  external int _unique_ifr_name_item_3;
  @ffi.Uint8()
  external int _unique_ifr_name_item_4;
  @ffi.Uint8()
  external int _unique_ifr_name_item_5;
  @ffi.Uint8()
  external int _unique_ifr_name_item_6;
  @ffi.Uint8()
  external int _unique_ifr_name_item_7;
  @ffi.Uint8()
  external int _unique_ifr_name_item_8;
  @ffi.Uint8()
  external int _unique_ifr_name_item_9;
  @ffi.Uint8()
  external int _unique_ifr_name_item_10;
  @ffi.Uint8()
  external int _unique_ifr_name_item_11;
  @ffi.Uint8()
  external int _unique_ifr_name_item_12;
  @ffi.Uint8()
  external int _unique_ifr_name_item_13;
  @ffi.Uint8()
  external int _unique_ifr_name_item_14;
  @ffi.Uint8()
  external int _unique_ifr_name_item_15;

  ArrayHelper_ifreq_ifr_name_level0 get ifr_name =>
      ArrayHelper_ifreq_ifr_name_level0(this, [IFNAMSIZ], 0, 0);

  @ffi.Int16()
  external int ifr_ifindex;
  // external sockaddr ifr_addr;
}

/// Helper for array `sa_data` in struct `sockaddr`.
class ArrayHelper_ifreq_ifr_name_level0 {
  final ifreq _struct;
  final List<int> dimensions;
  final int level;
  final int _absoluteIndex;
  int get length => dimensions[level];
  ArrayHelper_ifreq_ifr_name_level0(
      this._struct, this.dimensions, this.level, this._absoluteIndex);
  void _checkBounds(int index) {
    if (index >= length || index < 0) {
      throw RangeError(
          'Dimension $level: index not in range 0..$length exclusive.');
    }
  }

  int operator [](int index) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        return _struct._unique_ifr_name_item_0;
      case 1:
        return _struct._unique_ifr_name_item_1;
      case 2:
        return _struct._unique_ifr_name_item_2;
      case 3:
        return _struct._unique_ifr_name_item_3;
      case 4:
        return _struct._unique_ifr_name_item_4;
      case 5:
        return _struct._unique_ifr_name_item_5;
      case 6:
        return _struct._unique_ifr_name_item_6;
      case 7:
        return _struct._unique_ifr_name_item_7;
      case 8:
        return _struct._unique_ifr_name_item_8;
      case 9:
        return _struct._unique_ifr_name_item_9;
      case 10:
        return _struct._unique_ifr_name_item_10;
      case 11:
        return _struct._unique_ifr_name_item_11;
      case 12:
        return _struct._unique_ifr_name_item_12;
      case 13:
        return _struct._unique_ifr_name_item_13;
      case 14:
        return _struct._unique_ifr_name_item_14;
      case 15:
        return _struct._unique_ifr_name_item_15;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }

  void operator []=(int index, int value) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        _struct._unique_ifr_name_item_0 = value;
        break;
      case 1:
        _struct._unique_ifr_name_item_1 = value;
        break;
      case 2:
        _struct._unique_ifr_name_item_2 = value;
        break;
      case 3:
        _struct._unique_ifr_name_item_3 = value;
        break;
      case 4:
        _struct._unique_ifr_name_item_4 = value;
        break;
      case 5:
        _struct._unique_ifr_name_item_5 = value;
        break;
      case 6:
        _struct._unique_ifr_name_item_6 = value;
        break;
      case 7:
        _struct._unique_ifr_name_item_7 = value;
        break;
      case 8:
        _struct._unique_ifr_name_item_8 = value;
        break;
      case 9:
        _struct._unique_ifr_name_item_9 = value;
        break;
      case 10:
        _struct._unique_ifr_name_item_10 = value;
        break;
      case 11:
        _struct._unique_ifr_name_item_11 = value;
        break;
      case 12:
        _struct._unique_ifr_name_item_12 = value;
        break;
      case 13:
        _struct._unique_ifr_name_item_13 = value;
        break;
      case 14:
        _struct._unique_ifr_name_item_14 = value;
        break;
      case 15:
        _struct._unique_ifr_name_item_15 = value;
        break;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }
}

class sockaddr extends ffi.Struct {
  @ffi.Uint16()
  external int sa_family;

  @ffi.Uint8()
  external int _unique_sa_data_item_0;
  @ffi.Uint8()
  external int _unique_sa_data_item_1;
  @ffi.Uint8()
  external int _unique_sa_data_item_2;
  @ffi.Uint8()
  external int _unique_sa_data_item_3;
  @ffi.Uint8()
  external int _unique_sa_data_item_4;
  @ffi.Uint8()
  external int _unique_sa_data_item_5;
  @ffi.Uint8()
  external int _unique_sa_data_item_6;
  @ffi.Uint8()
  external int _unique_sa_data_item_7;
  @ffi.Uint8()
  external int _unique_sa_data_item_8;
  @ffi.Uint8()
  external int _unique_sa_data_item_9;
  @ffi.Uint8()
  external int _unique_sa_data_item_10;
  @ffi.Uint8()
  external int _unique_sa_data_item_11;
  @ffi.Uint8()
  external int _unique_sa_data_item_12;
  @ffi.Uint8()
  external int _unique_sa_data_item_13;

  /// Helper for array `sa_data`.
  ArrayHelper_sockaddr_sa_data_level0 get sa_data =>
      ArrayHelper_sockaddr_sa_data_level0(this, [14], 0, 0);
}

/// Helper for array `sa_data` in struct `sockaddr`.
class ArrayHelper_sockaddr_sa_data_level0 {
  final sockaddr _struct;
  final List<int> dimensions;
  final int level;
  final int _absoluteIndex;
  int get length => dimensions[level];
  ArrayHelper_sockaddr_sa_data_level0(
      this._struct, this.dimensions, this.level, this._absoluteIndex);
  void _checkBounds(int index) {
    if (index >= length || index < 0) {
      throw RangeError(
          'Dimension $level: index not in range 0..$length exclusive.');
    }
  }

  int operator [](int index) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        return _struct._unique_sa_data_item_0;
      case 1:
        return _struct._unique_sa_data_item_1;
      case 2:
        return _struct._unique_sa_data_item_2;
      case 3:
        return _struct._unique_sa_data_item_3;
      case 4:
        return _struct._unique_sa_data_item_4;
      case 5:
        return _struct._unique_sa_data_item_5;
      case 6:
        return _struct._unique_sa_data_item_6;
      case 7:
        return _struct._unique_sa_data_item_7;
      case 8:
        return _struct._unique_sa_data_item_8;
      case 9:
        return _struct._unique_sa_data_item_9;
      case 10:
        return _struct._unique_sa_data_item_10;
      case 11:
        return _struct._unique_sa_data_item_11;
      case 12:
        return _struct._unique_sa_data_item_12;
      case 13:
        return _struct._unique_sa_data_item_13;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }

  void operator []=(int index, int value) {
    _checkBounds(index);
    switch (_absoluteIndex + index) {
      case 0:
        _struct._unique_sa_data_item_0 = value;
        break;
      case 1:
        _struct._unique_sa_data_item_1 = value;
        break;
      case 2:
        _struct._unique_sa_data_item_2 = value;
        break;
      case 3:
        _struct._unique_sa_data_item_3 = value;
        break;
      case 4:
        _struct._unique_sa_data_item_4 = value;
        break;
      case 5:
        _struct._unique_sa_data_item_5 = value;
        break;
      case 6:
        _struct._unique_sa_data_item_6 = value;
        break;
      case 7:
        _struct._unique_sa_data_item_7 = value;
        break;
      case 8:
        _struct._unique_sa_data_item_8 = value;
        break;
      case 9:
        _struct._unique_sa_data_item_9 = value;
        break;
      case 10:
        _struct._unique_sa_data_item_10 = value;
        break;
      case 11:
        _struct._unique_sa_data_item_11 = value;
        break;
      case 12:
        _struct._unique_sa_data_item_12 = value;
        break;
      case 13:
        _struct._unique_sa_data_item_13 = value;
        break;
      default:
        throw Exception('Invalid Array Helper generated.');
    }
  }
}
