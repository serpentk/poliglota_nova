-module(load_sound_controller).
-export([
         load_sound/1
        ]).

-record(track, {lang, word, location}).

request_forvo(Lang, Word, Api_key) ->
    inets:start(),
    ssl:start(),
    Url = io_lib:format("https://apifree.forvo.com/key/~s/format/json/action/standard-pronunciation/word/~s/language/~s", [Api_key, Word, Lang]),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(Url),
    Data = jiffy:decode(Body),
    {[{<<"items">>, [{Item}]}]} = Data,
    #track{lang=Lang, word=Word, location=proplists:get_value(<<"pathmp3">>, Item)}.

load_sound(_Req) ->
    {json, #{status => <<"ok">>}}.
