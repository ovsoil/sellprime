-module(sellaprime_supervisor).
-behaviour(supervisor).

-export([start/0, start_link/1, start_in_shell_for_testing/0, init/1]).

start() ->
    spawn(fun() ->
            supervisor:start_link({local, ?MODULE}, ?MODULE, [], _Arg = [])
    end).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

start_in_shell_for_testing() ->
    {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid).

init([]) ->
    gen_event:swap_handler(alarm_handler,
                            {alarm_hander, swap},
                            {my_alarm_handler, xyz}),
    SupFlags = #{strategy => one_for_one, intensity => 3, period => 10},
    ChildSpecs = [#{id => tag1,
                    start => {area_server, start_link, []},
                    restart => permanent,
                    shutdown => 10000,
                    type => worker,
                    modules => [area_server]},
                #{id => tag2,
                    start => {prime_server, start_link, []},
                    restart => permanent,
                    shutdown => 10000,
                    type => worker,
                    modules => [prime_server]} 
            ],
    {ok, {SupFlags, ChildSpecs}}.

