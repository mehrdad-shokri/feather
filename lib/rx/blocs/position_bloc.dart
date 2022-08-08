import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/position_service.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';

class PositionBloc extends RxBloc {
  final _lastPosition = BehaviorSubject<Position>();
  final _locationPermission = BehaviorSubject<LocationPermission>();
  final _requestingLocationPermission = BehaviorSubject<bool>();
  final PositionService _positionService;

  Stream<Position> get position => _lastPosition.stream;

  Stream<bool> get requestingLocationPermission =>
      _requestingLocationPermission.stream;

  Stream<LocationPermission> get locationPermission =>
      _locationPermission.stream;

  PositionBloc(this._positionService) {
    _locationPermission.add(_positionService.hasPermission);
  }

  void getCurrentPosition(Function(Exception) onError) {
    addFutureSubscription(_positionService.getCurrentPosition(),
        (Position event) => _lastPosition.add(event), onError);
  }

  void requestPermission() {
    _requestingLocationPermission.add(true);
    addFutureSubscription(_positionService.requestPermission(),
        (LocationPermission permissionStatus) {
      _requestingLocationPermission.add(false);
      _locationPermission.add(permissionStatus);
    }, (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: Constants.TOAST_DEFAULT_LOCATION,
          timeInSecForIosWeb: 3,
          backgroundColor: Constants.ERROR_COLOR,
          textColor: Colors.white,
          fontSize: 16.0);
      _requestingLocationPermission.add(false);
    });
  }

  void checkPermission() {
    addFutureSubscription(_positionService.checkPermission(),
        (LocationPermission permission) => _locationPermission.add(permission));
  }
}
