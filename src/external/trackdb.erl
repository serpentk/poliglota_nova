-module(trackdb).
-export([
         save_track/2,
	 get_tracks/3
        ]).
-include_lib("track.hrl").

save_track(Track, Dbconfig) ->
    {ok, Conn} = epgsql:connect(Dbconfig),
    epgsql:equery(Conn, "insert into tracks (word, lang, location) values ($1, $2, $3)", [Track#track.word, Track#track.lang, Track#track.location]).

get_tracks(Word, Lang, Dbconfig) ->
    {ok, Conn} = epgsql:connect(Dbconfig),
    {ok, _Info, Locations} = epgsql:equery(Conn, "select location from tracks where word=$1 and lang=$2", [Word, Lang]),
Locations.
