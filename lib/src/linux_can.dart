// import 'dart:ffi';
// import 'bindings/libc_arm32.g.dart';

// const String _dylib = "libc.so.6";

// class LinuxCan {
//   final DynamicLibrary library = DynamicLibrary.open(_dylib);
//   late final LibCArm32 _backend = LibCArm32(library);

//   setup() {
//     _backend.socket(PF_CAN, SOCK_RAW, CAN_RAW);
//   }

//   // run() {
//   //   int s;
//   //   sockaddr_can addr;
//   //   ifreq ifr;

//   //   s = _backend.socket(PF_CAN, SOCK_RAW, CAN_RAW);

//   //   _backend.strcpy(ifr.ifr_name, "can0" );
//   //   _backend.ioctl(s, );

//   //   addr = AF_CAN;
//   //   addr.can_ifindex = ifr.ifr_ifindex;

//   //   bind(s, (struct sockaddr *)&addr, sizeof(addr));
//   // }
// }

// class CanBindings implements LinuxCan {
//   @override
//   // TODO: implement _backend
//   LibCArm32 get _backend => throw UnimplementedError();

//   @override
//   // TODO: implement library
//   DynamicLibrary get library => throw UnimplementedError();

//   @override
//   setup() {
//     // TODO: implement setup
//     throw UnimplementedError();
//   }

// }