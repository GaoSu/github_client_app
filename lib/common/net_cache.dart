import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:github_client_app/common/global.dart';

class CacheObject {
  CacheObject(this.response) : timeStamp = DateTime.now().microsecondsSinceEpoch;
  Response response;
  int timeStamp;
  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return response.hashCode == other.hashCode;
  }
  @override
  // TODO: implement hashCode
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  var cache = LinkedHashMap<String, CacheObject>();
  @override
  onRequest(RequestOptions options) async {
    // TODO: implement onRequest
    if (!Global.profile.cache.enable) return options;
    bool refresh = options.extra["refresh"] == true;
    if (refresh) {
      if (options.extra["list"] == true) {
        cache.removeWhere((key, value) => key.contains(options.path));
      } else {
         delete(options.uri.toString());
      }
    }
    if (options.extra["npCache"] != true && options.method.toLowerCase() == 'get') {
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        if((DateTime.now().microsecondsSinceEpoch - ob.timeStamp) / 1000 < Global.profile.cache.maxAge) {
          return cache[key].response;
        } else {
          cache.remove(key);
        }
      }
    }
  }

  @override
  onResponse(Response response) async {
    if (Global.profile.cache.enable) {
      _saveCahce(response);
    }

  }

  _saveCahce(Response object) {
    RequestOptions options = object.request;
    if (options.extra["noCache"] != true && options.method.toLowerCase() == "get") {
      if (cache.length == Global.profile.cache.maxCount) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(object);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}