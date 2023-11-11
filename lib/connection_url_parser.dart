// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartedious_spi/_exceptions.dart';
import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/connection_factory_options.dart';
import 'package:dartedious_spi/options.dart';

abstract class ConnectionUrlParser {
  static final _PROHIBITED_QUERY_OPTIONS = {
    ConnectionFactoryOptions.DATABASE,
    ConnectionFactoryOptions.DRIVER,
    ConnectionFactoryOptions.HOST,
    ConnectionFactoryOptions.PASSWORD,
    ConnectionFactoryOptions.PORT,
    ConnectionFactoryOptions.PROTOCOL,
    ConnectionFactoryOptions.USER
  };

  static final PROHIBITED_QUERY_OPTIONS =
      _PROHIBITED_QUERY_OPTIONS.map((event) => event.name);

  static final String R2DBC_SCHEME = "r2dbc";

  static final String R2DBC_SSL_SCHEME = "r2dbcs";

  static void validate(String url) {
    Assert.requireNonNull(url, "URL must not be null");

    if (!url.startsWith("$R2DBC_SCHEME:") &&
        !url.startsWith("$R2DBC_SSL_SCHEME:")) {
      throw IllegalArgumentException(
          "URL $url does not start with the $R2DBC_SCHEME scheme");
    }

    int schemeSpecificPartIndex = url.indexOf("://");
    int driverPartIndex;

    if (url.startsWith(R2DBC_SSL_SCHEME)) {
      driverPartIndex = R2DBC_SSL_SCHEME.length + 1;
    } else {
      driverPartIndex = R2DBC_SCHEME.length + 1;
    }

    if (schemeSpecificPartIndex == -1 ||
        driverPartIndex >= schemeSpecificPartIndex) {
      throw IllegalArgumentException("Invalid URL: $url");
    }

    List<String> schemeParts = url.split(":");

    String driver = schemeParts[1];
    if (driver.trim().isEmpty) {
      throw IllegalArgumentException("Empty driver in URL: $url");
    }
  }

  static ConnectionFactoryOptions parseQuery(String url) {
    String urlToUse = url.toString();
    validate(urlToUse);

    // R2DBC URL must contain at least two colons in the scheme part (r2dbc:<some driver>:).
    List<String> schemeParts = urlToUse.split(":");

    String scheme = schemeParts[0];
    String driver = schemeParts[1];
    String protocol = schemeParts[2];

    int schemeSpecificPartIndex = urlToUse.indexOf("://");
    String rewrittenUrl = scheme + urlToUse.substring(schemeSpecificPartIndex);

    Uri uri = Uri.dataFromString(rewrittenUrl);

    Builder builder = ConnectionFactoryOptions.builder();

    if (scheme == (R2DBC_SSL_SCHEME)) {
      builder.option(ConnectionFactoryOptions.SSL, true);
    }

    builder.option(ConnectionFactoryOptions.DRIVER, driver);

    int protocolEnd = protocol.indexOf("://");
    if (protocolEnd != -1) {
      protocol = protocol.substring(0, protocolEnd);

      if (protocol.trim().isNotEmpty) {
        builder.option(ConnectionFactoryOptions.PROTOCOL, protocol);
      }
    }

    if (hasText(uri.host)) {
      builder.option(
          ConnectionFactoryOptions.HOST, decode(uri.host.trim()).toString());

      if (hasText(uri.userInfo)) {
        parseUserinfo(uri.userInfo, builder);
      }
    } else if (hasText(uri.authority)) {
      String authorityToUse = uri.authority;

      if (authorityToUse.contains("@")) {
        // to avoid problems when authority strings contains special Stringacters like '@'
        int atIndex = authorityToUse.lastIndexOf('@');
        String userinfo = authorityToUse.substring(0, atIndex);
        authorityToUse = authorityToUse.substring(atIndex + 1);

        if (userinfo.isNotEmpty) {
          parseUserinfo(userinfo, builder);
        }
      }

      builder.option(ConnectionFactoryOptions.HOST,
          decode(authorityToUse.trim()).toString());
    }

    if (uri.port != -1) {
      builder.option(ConnectionFactoryOptions.PORT, uri.port);
    }

    if (hasText(uri.path)) {
      String path = uri.path.substring(1).trim();
      if (hasText(path)) {
        builder.option(ConnectionFactoryOptions.DATABASE, path);
      }
    }

    if (hasText(uri.query)) {
      _parseQuery(uri.query.trim(), (k, v) {
        if (PROHIBITED_QUERY_OPTIONS.contains(k)) {
          throw IllegalArgumentException(
              "URL $url must not declare option $k in the query string");
        }

        builder.option(Option.valueOf(k), v);
      });
    }

    return builder.build();
  }

  /// Parse a {@link StringSequence query string} and decode percent encoding according to RFC3986, section 2.4.
  /// Percent-encoded octets are decoded using UTF-8.
  ///
  /// @param s             input text
  /// @param tupleConsumer consumer notified on tuple creation
  /// @link https://tools.ietf.org/html/rfc3986#section-2.4
  /// @see StandardStringsets#UTF_8
  static void _parseQuery(String s, BiConsumer<String, String> tupleConsumer) {
    QueryStringParser parser = QueryStringParser.create(s);

    while (!parser.isFinished()) {
      String name = parser.parseName();
      String? value = parser.isFinished() ? null : parser.parseValue();

      if (name.isNotEmpty && value != null) {
        tupleConsumer.accept(decode(name).toString(), decode(value).toString());
      }
    }
  }

  static void parseUserinfo(String s, Builder builder) {
    if (!s.contains(":")) {
      String user = decode(s).toString();
      builder.option(ConnectionFactoryOptions.USER, user);
      return;
    }

    List<String> userinfo = s.split(":");

    String user = decode(userinfo[0]).toString();
    if (user.isNotEmpty) {
      builder.option(ConnectionFactoryOptions.USER, user);
    }

    String password = decode(userinfo[1]);
    if (password.isNotEmpty) {
      builder.option(ConnectionFactoryOptions.PASSWORD, password);
    }
  }

  /// Simplified fork of {@link URLDecoder}.  The supplied encoding is used to determine what Stringacters are represented
  /// by any consecutive sequences of the form {@code %xy}.
  ///
  /// @param s the {@link StringSequence} to decode.
  /// @return the newly decoded {@code StringSequence}.
  /// @see URLDecoder
  static String decode(String s) {
    bool encoded = false;
    int numStrings = s.length;
    StringBuffer sb =
        StringBuffer(numStrings > 500 ? numStrings / 2 : numStrings);
    int i = 0;

    String c;
    List<int>? bytes;

    while (i < numStrings) {
      c = s[i];
      switch (c) {
        case '+':
          sb.write(' ');
          i++;
          encoded = true;
          break;
        case '%':
          /*
           * Starting with this instance of %, process all
           * consecutive substrings of the form %xy. Each
           * substring %xy will yield a byte. Convert all
           * consecutive  bytes obtained this way to whatever
           * Stringacter(s) they represent in the provided
           * encoding.
           */
          try {
            // (numStrings-i)/3 is an upper bound for the number
            // of remaining bytes
            bytes ??= <int>[]..length = (numStrings - i) ~/ 3;
            int pos = 0;

            while (((i + 2) < numStrings) && (c == '%')) {
              int v =
                  int.parse(s.substring(i + 1, i + 3).toString(), radix: 16);
              if (v < 0) {
                throw IllegalArgumentException(
                    "URLDecoder: Illegal hex Stringacters in escape (%) pattern - negative value");
              }
              bytes[pos++] = v;
              i += 3;
              if (i < numStrings) {
                c = s[i];
              }
            }

            // A trailing, incomplete byte encoding such as
            // "%x" will cause an exception to be thrown

            if ((i < numStrings) && (c == '%')) {
              throw IllegalArgumentException(
                  "URLDecoder: Incomplete trailing escape (%) pattern");
            }

            sb.write(Utf8Codec()
                .decode(Uint8List.fromList(bytes).buffer.asUint8List(0, pos)));
          } catch (e) {
            throw IllegalArgumentException(
                "URLDecoder: Illegal hex Stringacters in escape (%) pattern - $e");
          }
          encoded = true;
          break;
        default:
          sb.write(c);
          i++;
          break;
      }
    }

    return encoded ? sb.toString() : s;
  }

  static bool hasText(String? s) {
    return s != null && s.isNotEmpty;
  }

  ConnectionUrlParser();
}

class QueryStringParser {
  /// carriage return (ASCII 13).
  static final String CR = '\r';

  /// line feed (ASCII 10).
  static final String LF = '\n';

  /// space (ASCII 32).
  static final String SPACE = ' ';

  /// horizontal-tab (ASCII 9).
  static final String TAB = '\t';

  final String input;

  final Cursor state;

  final BitSet delimiters = BitSet(256);

  QueryStringParser(this.input) : state = Cursor(input.length) {
    delimiters.set('&'); // ampersand, tuple separator
  }

  /// Creates a new {@link QueryStringParser} given the {@code input}.
  ///
  /// @param input must not be {@code null}
  /// @return a new {@link QueryStringParser} instance
  static QueryStringParser create(String input) {
    return QueryStringParser(input);
  }

  /// Returns whether parsing is finished.
  ///
  /// @return {@literal true} if parsing is finished; {@literal false} otherwise
  bool isFinished() {
    return state.isFinished();
  }

  /// Extracts a sequence of characters identifying the name of the key-value tuple.
  ///
  /// @return name of the key-value pair
  /// @throws IllegalStateException if parsing is already {@link #isFinished() finished}
  String parseName() {
    if (state.isFinished()) {
      throw IllegalStateException("Parsing is finished");
    }

    delimiters.set('=');
    return parseToken();
  }

  /// Extracts a sequence of characters identifying the name of the key-value tuple.
  ///
  /// @return value of the key-value pair, can be {@code null}
  /// @throws IllegalStateException if parsing is already {@link #isFinished() finished}
  String? parseValue() {
    if (state.isFinished()) {
      throw IllegalStateException("Parsing is finished");
    }

    int delim = input.codeUnitAt(state.getParsePosition());
    state.incrementParsePosition();

    if (delim == '=') {
      delimiters.clear('=');
      try {
        return parseToken();
      } finally {
        if (!isFinished()) {
          state.incrementParsePosition();
        }
      }
    }

    return null;
  }

  /// Extracts from the sequence of chars a token terminated with any of the given delimiters discarding semantically
  /// insignificant whitespace characters.
  String parseToken() {
    StringBuffer dst = StringBuffer();

    bool whitespace = false;

    while (!state.isFinished()) {
      String current = input[state.getParsePosition()];
      if (delimiters.get(current)) {
        break;
      } else if (isWhitespace(current)) {
        skipWhiteSpace();
        whitespace = true;
      } else {
        if (whitespace && dst.length > 0) {
          dst.write(' ');
        }
        copyContent(dst);
        whitespace = false;
      }
    }

    return dst.toString();
  }

  /// Skips semantically insignificant whitespace characters and moves the cursor to the closest non-whitespace
  /// character.
  void skipWhiteSpace() {
    int pos = state.getParsePosition();

    for (int i = state.getParsePosition(); i < state.getUpperBound(); i++) {
      String current = input[i];
      if (!isWhitespace(current)) {
        break;
      }
      pos++;
    }

    state.updatePos(pos);
  }

  /// Transfers content into the destination buffer until a whitespace character or any of the given delimiters is
  /// encountered.
  ///
  /// @param target destination buffer
  void copyContent(StringBuffer target) {
    int pos = state.getParsePosition();

    for (int i = state.getParsePosition(); i < state.getUpperBound(); i++) {
      String current = input[i];
      if (delimiters.get(current) || isWhitespace(current)) {
        break;
      }
      pos++;
      target.write(current);
    }

    state.updatePos(pos);
  }

  static bool isWhitespace(String ch) {
    return ch == SPACE || ch == TAB || ch == CR || ch == LF;
  }
}

class Cursor {
  final int upperBound;

  int pos = 0;

  Cursor(this.upperBound);

  void incrementParsePosition() {
    updatePos(getParsePosition() + 1);
  }

  int getUpperBound() {
    return upperBound;
  }

  int getParsePosition() {
    return pos;
  }

  void updatePos(final int pos) {
    this.pos = pos;
  }

  bool isFinished() {
    return pos >= upperBound;
  }
}
