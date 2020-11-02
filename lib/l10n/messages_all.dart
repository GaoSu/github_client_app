import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';


import 'message_messages.dart' as messages_messages;
import 'messages_zh_CN.dart' as messages_zh_cn;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'message': () => new Future.value(null),
  'zh_CN': () => new Future.value(null),
};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'messages':
      return messages_messages.messages;
    case 'zh_CN':
      return messages_zh_cn.messages;
    default:
      return null;
  }
}

Future<bool> initializeMessages(String localeName) async {
  // var availableLocale = Intl.verifiedLocale(localeName, (locale))
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
    onFailure: (_) => null
  );
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}