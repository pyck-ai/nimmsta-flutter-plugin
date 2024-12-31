enum NimmstaEventType {
  DID_SCAN_BARCODE,
  BATTERY_LEVEL_CHANGED,
  DID_CLICK_BUTTON,
  DID_DISCONNECT,
  DID_CONNECT_AND_INIT,
  DID_RECONNECT_AND_INIT,
  DID_RECEIVE_EVENT,
  DID_TOUCH
}

class NimmstaEvent {
  final NimmstaEventType type;
  final Map<String, dynamic>? data;

  NimmstaEvent(this.type, this.data);

  @override
  String toString() => 'NimmstaEvent(type: $type, data: $data)';
}