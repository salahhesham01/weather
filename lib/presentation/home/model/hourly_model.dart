class HourData {
  HourData({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.hourlyUnits,
    this.hourly,
  });
  late final double? latitude;
  late final double? longitude;
  late final double? generationtimeMs;
  late final int? utcOffsetSeconds;
  late final String? timezone;
  late final String? timezoneAbbreviation;
  late final double? elevation;
  late final HourlyUnits? hourlyUnits;
  late final Hourly? hourly;

  HourData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    hourlyUnits = HourlyUnits.fromJson(json['hourly_units']);
    hourly = Hourly.fromJson(json['hourly']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['generationtime_ms'] = generationtimeMs;
    _data['utc_offset_seconds'] = utcOffsetSeconds;
    _data['timezone'] = timezone;
    _data['timezone_abbreviation'] = timezoneAbbreviation;
    _data['elevation'] = elevation;
    _data['hourly_units'] = hourlyUnits?.toJson();
    _data['hourly'] = hourly?.toJson();
    return _data;
  }
}

class HourlyUnits {
  HourlyUnits({
    required this.time,
    required this.temperature_2m,
    required this.relativeHumidity_2m,
  });
  late final String time;
  late final String temperature_2m;
  late final String relativeHumidity_2m;

  HourlyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature_2m = json['temperature_2m'];
    relativeHumidity_2m = json['relative_humidity_2m'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['temperature_2m'] = temperature_2m;
    _data['relative_humidity_2m'] = relativeHumidity_2m;
    return _data;
  }
}

class Hourly {
  Hourly({
    required this.time,
    required this.temperature_2m,
    required this.relativeHumidity_2m,
  });
  late final List<dynamic> time;
  late final List<dynamic> temperature_2m;
  late final List<dynamic> relativeHumidity_2m;

  Hourly.fromJson(Map<String, dynamic> json) {
    time = List.castFrom<dynamic, dynamic>(json['time']);
    temperature_2m = List.castFrom<dynamic, dynamic>(json['temperature_2m']);
    relativeHumidity_2m =
        List.castFrom<dynamic, dynamic>(json['relative_humidity_2m']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['temperature_2m'] = temperature_2m;
    _data['relative_humidity_2m'] = relativeHumidity_2m;
    return _data;
  }
}
