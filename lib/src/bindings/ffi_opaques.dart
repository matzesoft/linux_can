import 'dart:ffi' as ffi;

// ignore: camel_case_types
class epoll_event extends ffi.Struct {
  @ffi.Uint32()
  int events;
  @ffi.Uint64()
  int userdata;
}

/// struct sockaddr_can - the sockaddr structure for CAN sockets
/// @can_family:  address family number AF_CAN.
/// @can_ifindex: CAN network interface index.
/// @can_addr:    protocol specific address information
// ignore: camel_case_types
class sockaddr_can extends ffi.Struct {
  @ffi.Uint32()
  int can_family;
  @ffi.Int64()
  int can_ifindex;
  // TODO: Check for right integer sizes
}
