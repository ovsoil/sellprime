-module(my_alarm_handler).
-behaviour(gen_event).

-export([init/1, code_change/3, handle_event/2, handle_call/2, handle_info/2, terminate/2]).

init(Args) ->
    io:format("*** my_alarm_handler init: ~p~n", [Args]),
    {ok, 0}.

handle_event({set_alarm, tooHot}, N) ->
    error_logger:error_msg("*** Tell the Enginneer to trun on the fan~n"),
    {ok, N + 1};
handle_event({clear_alarm, tooHot}, N) ->
    error_logger:error_msg("*** Danger over, turn off the fan~n"),
    {ok, N};
handle_event(Event, N) ->
    error_logger:error_msg("*** unmatched event ~p~n", [Event]),
    {ok, N}.

handle_call(_Request, N) ->
    Replay = N, {ok, Replay, N}.

handle_info(_Info, N) -> {ok, N}.
terminate(_Reason, _N) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.
