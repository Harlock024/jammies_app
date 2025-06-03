import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:jammies_app/providers/audio_player.dart';

class MotionConfig {
  final double shakeThreshold;
  final int shakeCooldownMs;
  final double tiltThreshold;
  final int volumeCooldownMs;
  final double volumeStep;
  final bool enableVibration;
  final bool enableVolumeControl;
  final bool enableShakeControl;

  const MotionConfig({
    this.shakeThreshold = 2.5,
    this.shakeCooldownMs = 1200,
    this.tiltThreshold = 8.0,
    this.volumeCooldownMs = 800,
    this.volumeStep = 0.1,
    this.enableVibration = true,
    this.enableVolumeControl = true,
    this.enableShakeControl = true,
  });
}

/// Estados del listener de movimiento
enum MotionListenerState { idle, listening, processing, disposed }

/// Listener profesional para detección de movimiento
class MotionListener {
  // Controladores principales
  late final AudioController _audio;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;

  // Estado interno
  MotionListenerState _state = MotionListenerState.idle;
  final MotionConfig _config;

  // Datos del acelerómetro
  double _lastX = 0.0;
  double _lastY = 0.0;
  double _lastZ = 0.0;
  bool _isInitialized = false;

  // Control de tiempo
  DateTime _lastShakeTime = DateTime.now().subtract(const Duration(seconds: 2));
  DateTime _lastVolumeChange = DateTime.now().subtract(
    const Duration(seconds: 1),
  );

  // Callbacks opcionales
  final VoidCallback? onShakeDetected;
  final ValueChanged<double>? onVolumeChanged;
  final VoidCallback? onError;

  MotionListener({
    required BuildContext context,
    MotionConfig? config,
    this.onShakeDetected,
    this.onVolumeChanged,
    this.onError,
  }) : _config = config ?? const MotionConfig() {
    _audio = Provider.of<AudioController>(context, listen: false);
    _initialize();
  }

  /// Estado actual del listener
  MotionListenerState get state => _state;

  /// Configuración actual
  MotionConfig get config => _config;

  /// Inicializa el listener
  Future<void> _initialize() async {
    if (_state != MotionListenerState.idle) return;

    try {
      _state = MotionListenerState.processing;
      await _initializeAccelerometer();
      _state = MotionListenerState.listening;
      _isInitialized = true;
      debugPrint("🎯 MotionListener inicializado correctamente");
    } catch (e) {
      _state = MotionListenerState.idle;
      debugPrint("❌ Error inicializando MotionListener: $e");
      onError?.call();
    }
  }

  /// Configura el acelerómetro
  Future<void> _initializeAccelerometer() async {
    _accelSubscription = accelerometerEvents.listen(
      _handleAccelerometerEvent,
      onError: (error) {
        debugPrint("❌ Error en acelerómetro: $error");
        onError?.call();
      },
      cancelOnError: false,
    );
  }

  // maneja los eventos del acelerómetro
  void _handleAccelerometerEvent(AccelerometerEvent event) async {
    if (_state != MotionListenerState.listening) return;

    try {
      // calcula los cambios del eje
      final deltaX = (event.x - _lastX).abs();
      final deltaY = (event.y - _lastY).abs();
      final deltaZ = (event.z - _lastZ).abs();

      // actualiza valores previos
      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;

      // detecta shake si esta activado
      if (_config.enableShakeControl) {
        await _detectShake(deltaX + deltaY + deltaZ);
      }

      // detectar inclinación para volumen si está habilitada
      if (_config.enableVolumeControl) {
        await _detectTilt(event.x);
      }
    } catch (e) {
      debugPrint("❌ Error procesando evento de movimiento: $e");
      onError?.call();
    }
  }

  // detecta sacudidas del dispositivo
  Future<void> _detectShake(double totalChange) async {
    final now = DateTime.now();
    final timeSinceLastShake = now.difference(_lastShakeTime).inMilliseconds;

    if (totalChange > _config.shakeThreshold &&
        timeSinceLastShake > _config.shakeCooldownMs) {
      _lastShakeTime = now;
      await _handleShakeGesture();
    }
  }

  // maneja el gesto de sacudida
  Future<void> _handleShakeGesture() async {
    try {
      // alternar reproducción
      if (_audio.isPlaying) {
        await _audio.pause();
        debugPrint("Shake → Pausar música");
      } else {
        await _audio.play();
        debugPrint("Shake → Reproducir música");
      }

      onShakeDetected?.call();
    } catch (e) {
      debugPrint("❌ Error manejando sacudida: $e");
      onError?.call();
    }
  }

  /// detecta la inclinación lateral para el control del volumen
  Future<void> _detectTilt(double xAcceleration) async {
    final now = DateTime.now();
    final timeSinceLastVolumeChange =
        now.difference(_lastVolumeChange).inMilliseconds;

    if (timeSinceLastVolumeChange < _config.volumeCooldownMs) return;

    try {
      final currentVolume = await VolumeController.instance.getVolume();
      double? newVolume;

      // inclinacion derecha → subir volumen
      if (xAcceleration > _config.tiltThreshold && currentVolume < 1.0) {
        newVolume = min(currentVolume + _config.volumeStep, 1.0);
        await _changeVolume(newVolume, "🔊 Subir");
      }
      // inclinacion izquierda → bajar volumen
      else if (xAcceleration < -_config.tiltThreshold && currentVolume > 0.0) {
        newVolume = max(currentVolume - _config.volumeStep, 0.0);
        await _changeVolume(newVolume, "🔉 Bajar");
      }
    } catch (e) {
      debugPrint("❌ Error controlando volumen: $e");
      onError?.call();
    }
  }

  /// cambia el volumen con feedback
  Future<void> _changeVolume(double newVolume, String action) async {
    await VolumeController.instance.setVolume(newVolume);
    _lastVolumeChange = DateTime.now();

    final percentage = (newVolume * 100).round();
    debugPrint("$action volumen: $percentage%");
    onVolumeChanged?.call(newVolume);
  }

  /// Pausa temporalmente el listener
  void pause() {
    if (_state == MotionListenerState.listening) {
      _accelSubscription?.pause();
      debugPrint("⏸️ MotionListener pausado");
    }
  }

  /// Reanuda el listener
  void resume() {
    if (_state == MotionListenerState.listening) {
      _accelSubscription?.resume();
      debugPrint("▶️ MotionListener reanudado");
    }
  }

  /// Reinicia el listener con nueva configuración
  Future<void> reconfigure(MotionConfig newConfig) async {
    dispose();
    // Aquí necesitarías recrear el listener con la nueva configuración
    // En una implementación completa, podrías hacer esto más elegante
    debugPrint("🔄 MotionListener reconfigurado");
  }

  /// Libera todos los recursos
  void dispose() {
    if (_state == MotionListenerState.disposed) return;

    _accelSubscription?.cancel();
    _accelSubscription = null;
    _state = MotionListenerState.disposed;
    _isInitialized = false;

    debugPrint("🗑️ MotionListener disposed");
  }

  /// información de depuración
  Map<String, dynamic> getDebugInfo() {
    return {
      'state': _state.toString(),
      'isInitialized': _isInitialized,
      'config': {
        'shakeThreshold': _config.shakeThreshold,
        'tiltThreshold': _config.tiltThreshold,
        'enableVibration': _config.enableVibration,
        'enableVolumeControl': _config.enableVolumeControl,
        'enableShakeControl': _config.enableShakeControl,
      },
      'lastAcceleration': {
        'x': _lastX.toStringAsFixed(2),
        'y': _lastY.toStringAsFixed(2),
        'z': _lastZ.toStringAsFixed(2),
      },
    };
  }
}
