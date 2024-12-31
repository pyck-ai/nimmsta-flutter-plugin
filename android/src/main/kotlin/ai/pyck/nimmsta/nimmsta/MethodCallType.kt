package ai.pyck.nimmsta.nimmsta

enum class MethodCallType(val method: String) {
    IS_CONNECTED("isConnected"),
    CONNECT("connect"),
    RECONNECT("reconnect"),
    DISCONNECT("disconnect"),
    SET_LAYOUT("setLayout"),
    SET_SCREEN_INFO_ASYNC("setScreenInfoAsync"),
    SET_LED_COLOR("setLEDColor"),
    TRIGGER_LED_BURST("triggerLEDBurst"),
    TRIGGER_VIBRATION_BURST("triggerVibrationBurst"),
    TRIGGER_BEEPER_BURST("triggerBeeperBurst"),
}