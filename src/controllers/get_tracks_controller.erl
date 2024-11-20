-module(get_tracks_controller).
-export([
         get_tracks/1
        ]).

get_tracks(#{parsed_qs := #{<<"lang">> := Lang, <<"word">> := Word}}) ->
    {ok, DbEnv} = application:get_env(poliglota_nova, dbconfig),
    Dbconfig = #{host => proplists:get_value(host, DbEnv), 
                 username => proplists:get_value(username, DbEnv), 
                 password => proplists:get_value(password, DbEnv), 
                 database => proplists:get_value(database, DbEnv)},
    Tracks = trackdb:get_tracks(Word, Lang, Dbconfig),
    {json, 200, #{}, [#{id => Id, location => Loc} || {Id, Loc} <- Tracks]};

get_tracks(_Req) ->
     {json, 400, #{}, #{error => <<"Wrong request params">>}}.
