-module(map).
-export([new/0, update/3, reachable/2, all_nodes/1]).

%create empty map
new() ->
    [].

	

%update the map with the links for the given node search for the node and replace if it is found 
%replace old links with new ones. if not then it is completely new node and links.
update(Node, Links, Map) ->
    FoundTuple = lists:keysearch(Node, 1, Map),
    case FoundTuple of
	{value, {Node, List}} ->
	    lists:keyreplace(Node, 1, Map, {Node, Links});
	false ->
	    [{Node, Links}|Map]
    end.
    
%search for the node in the map	
%if it is found return list if not return empty
reachable(Node, Map) ->
    FoundTuple = lists:keysearch(Node, 1, Map),
    case FoundTuple of
	{value, {Node, List}} ->
	    List;
	false ->
	    []
    end.
	
%list all nodes. Extract nodes with foldl function
%convert list to unique list.	
all_nodes(Map) ->
    Result = lists:foldl(fun({Node, Links}, Elements) -> 
      Elements ++ [Node] ++ Links end, [], Map),
    Set = sets:from_list(Result),
    sets:to_list(Set).
	  