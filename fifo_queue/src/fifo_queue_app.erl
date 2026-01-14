%%%-------------------------------------------------------------------
%% @doc fifo_queue public API
%% @end
%%%-------------------------------------------------------------------

-module(fifo_queue_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    fifo_queue_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
