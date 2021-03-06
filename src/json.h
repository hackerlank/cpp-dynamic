/*
 * Copyright 2014 Facebook, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 *
 * Serialize and deserialize folly::dynamic values as JSON.
 *
 * Before you use this you should probably understand the basic
 * concepts in the JSON type system:
 *
 *    Value  : String | Bool | Null | Object | Array | Number
 *    String : UTF-8 sequence
 *    Object : (String, Value) pairs, with unique String keys
 *    Array  : ordered list of Values
 *    Null   : null
 *    Bool   : true | false
 *    Number : (representation unspecified)
 *
 * ... That's about it.  For more information see http://json.org or
 * look up RFC 4627.
 *
 * If your dynamic has anything illegal with regard to this type
 * system, the serializer will throw.
 *
 * @author Jordan DeLong <delong.j@fb.com>
 */

#pragma once

#include "dynamic.h"
#include "range.h"
#include "conv.h"

//////////////////////////////////////////////////////////////////////

namespace json {

    struct ParseError : std::runtime_error 
    {
        explicit ParseError(int line)
            : std::runtime_error(to<std::string>("json parse error on line ", line))
        {}

        explicit ParseError(int line, std::string const& context,
            std::string const& expected)
            : std::runtime_error(to<std::string>("json parse error on line ", line,
            !context.empty() ? to<std::string>(" near `", context, '\'')
            : "",
            ": ", expected))
        {}

        explicit ParseError(std::string const& what)
            : std::runtime_error("json parse error: " + what)
        {}
    };


  struct serialization_opts 
  {
    explicit serialization_opts()
      : allow_non_string_keys(false)
      , javascript_safe(false)
      , pretty_formatting(false)
      , encode_non_ascii(false)
      , validate_utf8(false)
      , allow_trailing_comma(false)
      , sort_keys(false)
      , skip_invalid_utf8(false)
      , allow_nan_inf(false)
    {}

    // If true, keys in an object can be non-strings.  (In strict
    // JSON, object keys must be strings.)  This is used by dynamic's
    // operator<<.
    bool allow_non_string_keys;

    /*
     * If true, refuse to serialize 64-bit numbers that cannot be
     * precisely represented by fit a double---instead, throws an
     * exception if the document contains this.
     */
    bool javascript_safe;

    // If true, the serialized json will contain space and newlines to
    // try to be minimally "pretty".
    bool pretty_formatting;

    // If true, non-ASCII utf8 characters would be encoded as \uXXXX.
    bool encode_non_ascii;

    // Check that strings are valid utf8
    bool validate_utf8;

    // Allow trailing comma in lists of values / items
    bool allow_trailing_comma;

    // Sort keys of all objects before printing out (potentially slow)
    bool sort_keys;

    // Replace invalid utf8 characters with U+FFFD and continue
    bool skip_invalid_utf8;

    // true to allow NaN or INF values
    bool allow_nan_inf;
  };

  /*
   * Main JSON serialization routine taking folly::dynamic parameters.
   * For the most common use cases there are simpler functions in the
   * main folly namespace below.
   */
  std::string serialize(dynamic const&, serialization_opts const&);

  /*
   * Escape a string so that it is legal to print it in JSON text and
   * append the result to out.
   */

  void escapeString(StringPiece input,
                    std::string& out,
                    const serialization_opts& opts);
} // namespace json

//////////////////////////////////////////////////////////////////////

/*
 * Parse a json blob out of a range and produce a dynamic representing
 * it.
 */
dynamic parseJson(StringPiece, json::serialization_opts const&);
dynamic parseJson(StringPiece);

/*
 * Serialize a dynamic into a json string.
 */
std::string toJson(dynamic const&);

/*
 * Same as the above, except format the json with some minimal
 * indentation.
 */
std::string toPrettyJson(dynamic const&);

/*
 * Encode a single unicode code point into a UTF-8 byte sequence.
 *
 * Return value is undefined if `cp' is an invalid code point.
 */
std::string codePointToUtf8(char32_t cp);
