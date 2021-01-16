-module(dijkstra).
-export([entry/2, replace/4, update/4, iterate/3, table/2, route/2]).

%it returns the length of the shortest path to the node
entry(Node, Sorted) ->
    Entry = lists:keysearch(Node, 1, Sorted),
    case Entry of
	  {value, {Node, Cost, Gateway}} ->
	     Cost;
	  false ->
	      0
    end.

%search through the map, and update the map with new length and gateway.
replace(Node, N, Gateway, Sorted) ->
    Entry = lists:keysearch(Node, 1, Sorted),
	case Entry of
	 {value, {Node, OldCost, OldGateway}} ->
	   UpdatedList = lists:keyreplace(Node, 1, Sorted, {Node, N, Gateway}),
	   lists:keysort(2, UpdatedList);
	 false ->
	   Sorted
    end .
	
	
	
%this function is for checking if the new direction has better cost or not
%if the cost is better replace the cost and gateway
update(Node, N, Gateway, Sorted) ->
    Cost = entry(Node, Sorted),
    if N < Cost ->
	    replace(Node, N, Gateway, Sorted);
     true ->
	    Sorted
    end.
	
	
%three types of iterate function.
%the iterate function when the first entry is empty
iterate([], Map, Table) ->
    Table;
%When the first entry with the infinite and unkown entry
iterate([{Node, inf, Gateway}|T], Map, Table) ->
    Table;
iterate([{Node, Length, Gateway}|Tail], Map, Table) ->
    ReachableNodes = map:reachable(Node, Map),
	New = lists:foldl(fun(N, Sorted) -> update(N, Length+1, Gateway, Sorted) end, Tail, ReachableNodes),
    iterate(New, Map, [{Node, Gateway}|Table]).
	
%conctructing the routing table given gateways and Map	
%first have the initial list with the dummy entries
table(Gateways, Map)  ->
    All_nodes = map:all_nodes(Map),
	InitialList = lists:map(fun(Node) -> {Node, inf, unknown} end, All_nodes),
    SortedList = lists:foldl(fun(Node, L) -> update(Node, 0, Node, L) end, InitialList, Gateways),
    iterate(SortedList, Map, []).
	
	
route(Node, Table) ->
    Result = lists:keysearch(Node, 1, Table),
    case Result of
	{value, {Node, Gateway}} ->
	    {ok, Gateway};
	false ->
	    notfound
    end.
	