import 'package:aventura/models/GeolocationModel.dart';

class AttractionModel {
  String _id;
  String _country;
  String _type;
  GeolocationModel _geolocationData;
  String _enName;
  String _koName;
  String _enSummaryDesc;
  String _koSummaryDesc;
  List<String> _imageUrls;

  AttractionModel(this._id, this._country, this._type, this._geolocationData,this._enName, this._koName, this._enSummaryDesc, this._koSummaryDesc);


  @override
  String toString() {
    return 'AttractionModel{_id: $_id, _country: $_country, _type: $_type, _geolocationData: $_geolocationData, _enName: $_enName, _koName: $_koName, _enSummaryDesc: $_enSummaryDesc, _koSummaryDesc: $_koSummaryDesc, _imageUrls: $_imageUrls}';
  }


  set imageUrls(List<String> value) {
    _imageUrls = value;
  }

  List<String> get imageUrls => _imageUrls;

  String get id => _id;

  String get enName => _enName;

  String get country => _country;

  String get type => _type;

  GeolocationModel get geolocationData => _geolocationData;

  String get koName => _koName;

  String get enSummaryDesc => _enSummaryDesc;

  String get koSummaryDesc => _koSummaryDesc;
}
