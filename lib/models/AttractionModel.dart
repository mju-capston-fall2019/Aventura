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

  AttractionModel(this._id, this._country, this._type, this._geolocationData,this._enName, this._koName, this._enSummaryDesc, this._koSummaryDesc);

  @override
  String toString() {
    print("id ${this._id}");
    print(this._country);
    print(this._type);
    print(this._geolocationData);
    print(this._enName);
    print(this._koName);
    print(this._enSummaryDesc);
    print(this._koSummaryDesc);
    return super.toString();
  }


  String get id => _id;

  String get enName => _enName;

  String get country => _country;

  String get type => _type;

  GeolocationModel get geolocationData => _geolocationData;

  String get koName => _koName;

  String get enSummaryDesc => _enSummaryDesc;

  String get koSummaryDesc => _koSummaryDesc;
}
