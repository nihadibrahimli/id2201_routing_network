-module(hist).
-export([new/1, update/3]).

new(Name) ->
  [{Name, inf}].


update(Node, N, History) ->
    Entry = lists:keyfind(Node, 1, History),
    case Entry of
    {Node, NewMessage} ->
	    if N > NewMessage ->
		    {new, lists:keyreplace(Node, 1, History, {Node, N})};
		true ->
		    old		   
		end;
	false ->
	   {new, [{Node, N}|History]}
	end.