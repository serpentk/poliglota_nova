-module(forvo).
-export([
         request_forvo/3
        ]).
-include_lib("track.hrl").


make_filename(FBody) -> 
io_lib:format("./priv/static/tracks/~32.16.0b.mp3", [binary:decode_unsigned(crypto:hash(md5, FBody))]).

api_url(Lang, Word, Api_key) ->
  uri_string:normalize(
    #{scheme => "https", 
      host => "apifree.forvo.com", 
      path => io_lib:format( 
        "/key/~s/format/json/action/standard-pronunciation/word/~ts/language/~s", 
        [Api_key, Word, Lang])}).

request_forvo(Lang, Word, ApiKey) ->
    inets:start(),
    ssl:start(),
    Url = api_url(Lang, Word, ApiKey),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(Url),
    Data = jiffy:decode(Body),
    {[{<<"items">>, [{Item}]}]} = Data,
    Mp3Url = proplists:get_value(<<"pathmp3">>, Item),
    {ok, {_V, _H, FileBody}} = httpc:request(Mp3Url),
    FileName = make_filename(FileBody),
    file:write_file(FileName, FileBody),
    #track{lang=Lang, word=Word, location=FileName}.
