-module(load_sound_controller).
-export([
         load_sound/1
        ]).
-include_lib("track.hrl").

load_sound(#{json := #{<<"lang">> := Lang, <<"word">> := Word}}) ->
    {ok, ApiKey} = application:get_env(poliglota_nova, forvo_key),
    Track = forvo:request_forvo(Lang, Word, ApiKey),
    {ok, DbEnv} = application:get_env(poliglota_nova, dbconfig),
    Dbconfig = #{host => proplists:get_value(host, DbEnv), 
                 username => proplists:get_value(username, DbEnv), 
                 password => proplists:get_value(password, DbEnv), 
                 database => proplists:get_value(database, DbEnv)},
    trackdb:save_track(Track, Dbconfig),
    {json, 200, #{}, #{path => list_to_binary(Track#track.location)}};
load_sound(_Req) -> 
{json, 400, #{}, #{error => <<"Wrong request params">>}}.

