# Linux CAN

Dart implementation of SocketCAN.

Big shout out to [@ardera](https://github.com/ardera) who helped me a lot developing this package.

## Using the package
There are no system dependenices needed, except the `libc.so.6` which probably should be installed on your device.

### Setup
At first create a `CanDevice`. You can set a custom bitrate, default is 500 000. Afterwards call `setup()`. A `SocketException` will be thrown if something goes wrong.
```dart
final canDevice = CanDevice(bitrate: 250000);
await canDevice.setup();
```

### Communication
To receive data use `read()`, which returns a `CanFrame`. It contains the id and data of the frame.
```dart
final frame = canDevice.read();
print("Frame id: ${frame.id}");
print("Frame data: ${frame.data}");
```

To close the socket use `close()`.

## Limitations
- For now only `can0` is supported as an interface.
- You can not change the bitrate once it is set. To change the bitrate a reboot of your device is currently needed.
- Because I have no hardware to test, only reading is supported. If you are intrested in the package and have the hardware, feel free to contact me and get it on the way.
