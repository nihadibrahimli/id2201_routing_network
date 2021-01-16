-module(intf).
-export([list/1, add/4, remove/2, ref/2, name/2, broadcast/2, lookup/2, new/0]).

%create empty set of interfaces
new() ->  [].

%adding a new entry to the set and return the new set of interfaces
add(Name, Ref, Pid, Intf) -> 
    [{Name, Ref, Pid}|Intf].

%remove the entry from the list
%with the help of keydelete function	
remove(Name, Intf) ->
    lists:keydelete(Name, 1, Intf).
	
%keyfind is better to use.keyfind returns tuple, but keysearch returns {value,tuple}.
lookup(Name, Intf) ->
    Entry = lists:keyfind(Name, 1, Intf),
	case Entry of
      {Name, Ref, Pid} ->
	    {ok, Pid};
	false ->
	    notfound
	end.
	
%find the reference fiven a name
%using keyfind	
ref(Name, Intf) ->
  Entry = lists:keyfind(Name, 1, Intf),
  case Entry of
      {Name, Ref, Pid} ->
	    {ok, Ref};
	false ->
	    notfound
	end.
	
	
	
name(Ref, Intf) ->
  Entry = lists:keyfind(Ref, 2, Intf),
  case Entry of
      {Name, Ref, Pid} ->
	    {ok, Name};
	false ->
	    notfound
	end.
	
	
list(Intf) ->
   lists:foldl(fun({Name, Ref, Pid}, Names) -> 
    Names ++ [Name] end, [], Intf).
   

	
%send message to all interfaces
broadcast(Message, Intf) -> 
  lists:foreach(fun({Name, Ref, Pid}) -> Pid ! Message end, Intf).
 
