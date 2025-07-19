import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoiceRecordingButton extends StatefulWidget {
  final VoidCallback? onRecordingStart;
  final VoidCallback? onRecordingStop;
  final VoidCallback? onRecordingCancel;
  final bool isRecording;

  const VoiceRecordingButton({
    super.key,
    this.onRecordingStart,
    this.onRecordingStop,
    this.onRecordingCancel,
    this.isRecording = false,
  });

  @override
  State<VoiceRecordingButton> createState() => _VoiceRecordingButtonState();
}

class _VoiceRecordingButtonState extends State<VoiceRecordingButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isPressed = false;
  bool _isRecording = false;
  Duration _recordingDuration = Duration.zero;
  late Timer _recordingTimer;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    _recordingTimer.cancel();
    super.dispose();
  }

  void _startRecording() {
    if (_isRecording) return;
    
    setState(() {
      _isRecording = true;
      _recordingDuration = Duration.zero;
    });
    
    _pulseController.repeat(reverse: true);
    HapticFeedback.mediumImpact();
    
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration += const Duration(seconds: 1);
      });
    });
    
    widget.onRecordingStart?.call();
  }

  void _stopRecording() {
    if (!_isRecording) return;
    
    setState(() {
      _isRecording = false;
    });
    
    _pulseController.stop();
    _pulseController.reset();
    _recordingTimer.cancel();
    HapticFeedback.lightImpact();
    
    widget.onRecordingStop?.call();
  }

  void _cancelRecording() {
    if (!_isRecording) return;
    
    setState(() {
      _isRecording = false;
    });
    
    _pulseController.stop();
    _pulseController.reset();
    _recordingTimer.cancel();
    HapticFeedback.heavyImpact();
    
    widget.onRecordingCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
        _scaleController.forward();
        _startRecording();
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        _scaleController.reverse();
        _stopRecording();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
        _scaleController.reverse();
        _cancelRecording();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _isRecording 
                ? _pulseAnimation.value 
                : _scaleAnimation.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording 
                    ? Colors.red 
                    : (_isPressed ? Colors.orange.shade600 : Colors.orange),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
} 