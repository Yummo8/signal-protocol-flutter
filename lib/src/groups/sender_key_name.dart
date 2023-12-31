import 'package:meta/meta.dart';

import '../signal_protocol_address.dart';

@immutable
class SenderKeyName {
  const SenderKeyName(this._groupId, this._sender);

  final String _groupId;
  final SignalProtocolAddress _sender;

  String get groupId => _groupId;

  SignalProtocolAddress get sender => _sender;

  String serialize() =>
      '$_groupId::${_sender.getName()}::${_sender.getDeviceId()}';

  @override
  bool operator ==(Object other) {
    if (other is! SenderKeyName) return false;

    return _groupId == other.groupId && _sender == other.sender;
  }

  @override
  int get hashCode => _groupId.hashCode ^ _sender.hashCode;
}
