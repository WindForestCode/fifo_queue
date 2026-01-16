
-module(fifo_queue).

-behaviour(gen_server).

%% API
-export([stop/0, start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([get_list/0, add_element/1, delete_element/0]).

-record(state, {list = []}).

%% API
stop() ->
    gen_server:call(?MODULE, stop).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_list() ->
    gen_server:call(?MODULE, {get_state}).

add_element(Element) ->
    gen_server:call(?MODULE, {add_element, Element}).

delete_element() ->
    gen_server:call(?MODULE, {delete_element}).

%% Callback fun
init(_Args) ->
    {ok, #state{}}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};

%% Получение всего списка
handle_call({get_state}, _From, State) ->
    Reply = State#state.list,
    {reply, Reply, State};

%% Добавление элемента в список
handle_call({add_element, Element}, _From, State) ->
    CurrentList = State#state.list,

    NewList = CurrentList ++ [Element],

    NewState = State#state{list = NewList},
    {reply, ok, NewState};

%%  Удаление элемента
handle_call({delete_element}, _From, State) ->
    CurrentList = State#state.list,

    case CurrentList of 
        [_ | Tail] ->
            NewList = Tail,
            {reply, ok, State#state{list = NewList}};
        [] ->
            {reply, empty, State}
    end.    

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.