package ai.pyck.nimmsta.nimmsta

import android.app.Activity
import com.nimmsta.barcode.Barcode
import com.nimmsta.core.android.framework.NIMMSTAServiceConnection
import com.nimmsta.core.shared.device.BluetoothDeviceMacAddress
import com.nimmsta.core.shared.device.NIMMSTADevice
import com.nimmsta.core.shared.device.NIMMSTAEventHandler
import com.nimmsta.core.shared.exception.bluetooth.BluetoothDisconnectedException
import com.nimmsta.core.shared.layout.element.Button
import com.nimmsta.core.shared.layout.event.ButtonClickEvent
import com.nimmsta.core.shared.textprotocol.event.Event
import com.nimmsta.core.shared.textprotocol.event.ScanEvent
import com.nimmsta.core.shared.textprotocol.event.TouchEvent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NimmstaPlugin */
class NimmstaPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, NIMMSTAEventHandler,
    EventChannel.StreamHandler {

    private lateinit var methodChannel: MethodChannel

    private lateinit var eventChannel: EventChannel

    private var eventSink: EventChannel.EventSink? = null

    private lateinit var serviceConnection: NIMMSTAServiceConnection

    private lateinit var activity: Activity

    // MethodCallHandler
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "nimmsta/methods")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "nimmsta/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == MethodCallType.IS_CONNECTED.method) {
            result.success(isConnected())
        } else if (call.method == MethodCallType.CONNECT.method) {
            connect()
            result.success(null)
        } else if (call.method == MethodCallType.RECONNECT.method) {
            call.argument<String>("address")?.let { reconnect(it) }
            result.success(null)
        } else if (call.method == MethodCallType.DISCONNECT.method) {
            disconnect()
            result.success(null)
        } else if (call.method == MethodCallType.SET_LAYOUT.method) {
            val layout = call.argument<String>("layout")
            val data = call.argument<Map<String, String>>("data")
            if (layout != null && data != null) {
                setLayout(layout, data)
                result.success(null)
            } else {
                result.notImplemented()
            }
        } else if (call.method == MethodCallType.SET_SCREEN_INFO_ASYNC.method) {
            val data = call.argument<Map<String, String>>("data")
            if (data != null) {
                setScreenInfoAsync(data)
                result.success(null)
            } else {
                result.notImplemented()
            }
        } else if (call.method == MethodCallType.SET_LED_COLOR.method) {
            val r = call.argument<Int>("r")
            val g = call.argument<Int>("g")
            val b = call.argument<Int>("b")
            if (r != null && g != null && b != null) {
                setLEDColor(r, g, b)
                result.success(null)
            } else {
                result.notImplemented()
            }
        } else if (call.method == MethodCallType.TRIGGER_LED_BURST.method) {
            val repeat = call.argument<Int>("repeat")
            val duration = call.argument<Int>("duration")
            val pulseDuration = call.argument<Int>("pulseDuration")
            val r = call.argument<Int>("r")
            val g = call.argument<Int>("g")
            val b = call.argument<Int>("b")
            if (repeat != null && duration != null && pulseDuration != null && r != null && g != null && b != null) {
                triggerLEDBurst(repeat, duration, pulseDuration, r, g, b)
            }
            result.success(null)
        } else if (call.method == MethodCallType.TRIGGER_VIBRATION_BURST.method) {
            val repeat = call.argument<Int>("repeat")
            val duration = call.argument<Int>("duration")
            val pulseDuration = call.argument<Int>("pulseDuration")
            val intensity = call.argument<Int>("intensity")
            if (repeat != null && duration != null && pulseDuration != null && intensity != null) {
                triggerVibrationBurst(repeat, duration, pulseDuration, intensity)
            }
            result.success(null)
        } else if (call.method == MethodCallType.TRIGGER_BEEPER_BURST.method) {
            val repeat = call.argument<Int>("repeat")
            val duration = call.argument<Int>("duration")
            val pulseDuration = call.argument<Int>("pulseDuration")
            val intensity = call.argument<Int>("intensity")
            if (repeat != null && duration != null && pulseDuration != null && intensity != null) {
                triggerBeeperBurst(repeat, duration, pulseDuration, intensity)
            }
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
    }

    // EventChannel.StreamHandler
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    // ActivityAware
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    // NIMMSTAEventHandler
    override fun didConnectAndInit(device: NIMMSTADevice) {
        if (device.connectCount > 1) {
            sendEvent(
                EventType.DID_RECONNECT_AND_INIT,
                mapOf("device" to device.address.toString())
            )
            return
        }

        sendEvent(EventType.DID_CONNECT_AND_INIT, mapOf("device" to device.address.toString()))
    }

    override fun didDisconnect(
        device: NIMMSTADevice,
        reason: BluetoothDisconnectedException.Reason
    ) {
        super.didDisconnect(device, reason)
        sendEvent(EventType.DID_DISCONNECT)
    }

    override fun didReceiveEvent(device: NIMMSTADevice, event: Event) {
        super.didReceiveEvent(device, event)
        sendEvent(EventType.DID_RECEIVE_EVENT, mapOf("event" to event.eventName))
    }

    override fun onError(device: NIMMSTADevice?, throwable: Throwable): Boolean {
        return false
    }

    override fun didScanBarcode(device: NIMMSTADevice, barcode: Barcode, event: ScanEvent) {
        sendEvent(EventType.DID_SCAN_BARCODE, mapOf("barcode" to barcode.barcode))
    }

    override fun didClickButton(device: NIMMSTADevice, sender: Button?, event: ButtonClickEvent) {
        sendEvent(
            EventType.DID_CLICK_BUTTON,
            mapOf("button" to sender?.name.toString())
        )
    }

    override fun didTouch(
        device: NIMMSTADevice,
        x: Double,
        y: Double,
        screen: Int,
        event: TouchEvent
    ) {
        sendEvent(
            EventType.DID_TOUCH,
            mapOf("x" to x, "y" to y)
        )
    }

    override fun batteryLevelChanged(device: NIMMSTADevice, newBatteryLevel: Int) {
        sendEvent(
            EventType.BATTERY_LEVEL_CHANGED,
            mapOf("newBatteryLevel" to newBatteryLevel)
        )
    }

    // Private Methods
    private fun sendEvent(eventType: EventType, data: Map<String, Any> = emptyMap()) {
        val event = mapOf("type" to eventType.name, "data" to data)

        activity.runOnUiThread {
            eventSink?.success(event)
        }
    }

    private fun isConnected(): Boolean {
        if (!::serviceConnection.isInitialized) {
            return false
        }

        val manager = serviceConnection.connectionManager

        if (manager != null) {
            val deviceList = manager.devices.connectedDevices

            for (device in deviceList) {
                if (device.isConnected) {
                    return true
                }
            }
        }

        return false
    }

    private fun connect() {
        serviceConnection =
            NIMMSTAServiceConnection.bindServiceToActivity(activity, this).onComplete {
                try {
                    // this is the point in time when the (background) task completes and the result throws if an error occurred.
                    it.result
                    it.result.enableBackgroundAndNotifications()

                    // Check if connected, if not show connection Activity
                    if (!serviceConnection.hasActiveConnections) {
                        serviceConnection.displayConnectionActivity()
                    }
                } catch (throwable: Throwable) {
                    throwable.printStackTrace()
                }
            }
    }

    private fun reconnect(deviceAddress: String) {
        serviceConnection =
            NIMMSTAServiceConnection.bindServiceToActivity(activity, this).onComplete {
                try {
                    it.result
                    it.result.enableBackgroundAndNotifications()

                    serviceConnection.connectionManager?.connectAsync(
                        BluetoothDeviceMacAddress(
                            deviceAddress
                        )
                    )
                } catch (throwable: Throwable) {
                    throwable.printStackTrace()
                }
            }
    }

    private fun disconnect() {
        serviceConnection.close()
        sendEvent(EventType.DID_DISCONNECT)
    }

    private fun setLayout(layout: String, data: Map<String, String>) {
        val device = getConnectedDevice()
        device?.setLayout(layout, data)
    }

    private fun setScreenInfoAsync(dataToInject: Map<String, String>) {
        val device = getConnectedDevice()
        device?.setScreenInfoAsync(dataToInject, false)
    }

    private fun setLEDColor(r: Int, g: Int, b: Int) {
        val device = getConnectedDevice()
        device?.api?.setLEDColor(r, g, b, null)
    }

    private fun triggerLEDBurst(
        repeat: Int,
        duration: Int,
        pulseDuration: Int,
        r: Int,
        g: Int,
        b: Int
    ) {
        val device = getConnectedDevice()
        device?.api?.triggerLEDBurst(repeat, duration, pulseDuration, r, g, b, null)
    }

    private fun triggerVibrationBurst(
        repeat: Int,
        duration: Int,
        pulseDuration: Int,
        intensity: Int
    ) {
        val device = getConnectedDevice()
        device?.api?.triggerVibratorBurst(repeat, duration, pulseDuration, intensity, null)
    }

    private fun triggerBeeperBurst(repeat: Int, duration: Int, pulseDuration: Int, intensity: Int) {
        val device = getConnectedDevice()
        device?.api?.triggerBeeperBurst(repeat, duration, pulseDuration, intensity, null)
    }

    private fun getConnectedDevice(): NIMMSTADevice? {
        return serviceConnection.connectionManager?.devices?.connectedDevices
            ?.firstOrNull { it.isConnected }
    }
}
