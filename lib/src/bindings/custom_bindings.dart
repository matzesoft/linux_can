import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

const int SIOCGIFINDEX = 0x8933;

// ignore: camel_case_types
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
// ignore: camel_case_types
class sockaddr_can extends ffi.Struct {
  @ffi.Uint16()
  external int can_family;

  @ffi.Int16()
  external int can_ifindex;

  external tp_struct tp;
}

// ignore: camel_case_types
class tp_struct extends ffi.Struct {
  @ffi.Uint32()
  external int rx_id;

  @ffi.Uint32()
  external int tx_id;
}

// ignore: camel_case_types
class ifreq extends ffi.Struct {
  external ffi.Pointer<Utf8> ifr_name;

  @ffi.Int16()
  external int ifr_ifindex;
}