import 'package:twitter/twitter.dart';
import 'package:caio_bot/auth.dart';
import 'package:meta/meta.dart';

mixin AuthenticationMixin {
  // This is used mostly to signalize that the class
  // will be using twitter.

  @protected
  Twitter authenticate() {
    return Twitter.fromMap(credentials);
  }
}