class WeekData {
  WeekData({
    this.latitude,
    this.longitude,
    this.generationtimeMs,
    this.utcOffsetSeconds,
    this.timezone,
    this.timezoneAbbreviation,
    this.elevation,
    this.currentUnits,
    this.current,
    this.dailyUnits,
    this.daily,
  });
  late final double? latitude;
  late final double? longitude;
  late final double? generationtimeMs;
  late final int? utcOffsetSeconds;
  late final String? timezone;
  late final String? timezoneAbbreviation;
  late final double? elevation;
  late final dynamic currentUnits;
  late final dynamic current;
  late final dynamic dailyUnits;
  late final Daily? daily;

  WeekData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    generationtimeMs = json['generationtime_ms'];
    utcOffsetSeconds = json['utc_offset_seconds'];
    timezone = json['timezone'];
    timezoneAbbreviation = json['timezone_abbreviation'];
    elevation = json['elevation'];
    currentUnits = CurrentUnits.fromJson(json['current_units']);
    current = Current.fromJson(json['current']);
    dailyUnits = DailyUnits.fromJson(json['daily_units']);
    daily = Daily.fromJson(json['daily']);
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
    _data['current_units'] = currentUnits.toJson();
    _data['current'] = current.toJson();
    _data['daily_units'] = dailyUnits.toJson();
    _data['daily'] = daily?.toJson();
    return _data;
  }
}

class CurrentUnits {
  CurrentUnits({
    required this.time,
    required this.interval,
  });
  late final String time;
  late final String interval;

  CurrentUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    interval = json['interval'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['interval'] = interval;
    return _data;
  }
}

class Current {
  Current({
    required this.time,
    required this.interval,
  });
  late final String time;
  late final int interval;

  Current.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    interval = json['interval'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['interval'] = interval;
    return _data;
  }
}

class DailyUnits {
  DailyUnits({
    required this.time,
    required this.temperature_2mMax,
  });
  late final String time;
  late final String temperature_2mMax;

  DailyUnits.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature_2mMax = json['temperature_2m_max'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['temperature_2m_max'] = temperature_2mMax;
    return _data;
  }
}

class Daily {
  Daily({
    required this.time,
    required this.temperature_2mMax,
  });
  late final List<dynamic> time;
  late final List<dynamic> temperature_2mMax;

  Daily.fromJson(Map<String, dynamic> json) {
    time = List.castFrom<dynamic, dynamic>(json['time']);
    temperature_2mMax =
        List.castFrom<dynamic, dynamic>(json['temperature_2m_max']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['temperature_2m_max'] = temperature_2mMax;
    return _data;
  }
}
