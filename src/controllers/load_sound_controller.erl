-module(load_sound_controller).
-export([
         load_sound/1
        ]).

load_sound(_Req) ->
    {json, #{status => "ok"}}.
