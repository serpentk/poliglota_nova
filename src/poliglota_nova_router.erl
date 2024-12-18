-module(poliglota_nova_router).
-behaviour(nova_router).

-export([
         routes/1
        ]).

%% The Environment-variable is defined in your sys.config in {nova, [{environment, Value}]}
routes(_Environment) ->
    [#{prefix => "",
      security => false,
      routes => [
                 {"/", fun poliglota_nova_main_controller:index/1 , #{methods => [get]}},
		 {"/load", fun load_sound_controller:load_sound/1, #{methods => [post]}},
		 {"/tracks", fun get_tracks_controller:get_tracks/1, #{methods => [get]}},
                 {"/heartbeat", fun(_) -> {status, 200} end, #{methods => [get]}}
                ]
      }].
