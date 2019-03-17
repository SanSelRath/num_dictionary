%%%-------------------------------------------------------------------
%%% @author santhosh-6358
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Mar 2019 4:17 AM
%%%-------------------------------------------------------------------
-module(number_dict).
-author("santhosh-6358").

%% API
-export([num_to_alphabet/3,number_splitup/1,check_string/3,eff_file_create/0]).


number_splitup(Number) -> string_content(num_to_alphabet(Number,Number rem 10,[])).

num_to_alphabet(N,Rem,Result) when N >9 -> NewNum = (N - Rem) div 10, num_to_alphabet(NewNum,NewNum rem 10,[num_to_alpha_list(Rem)|Result]);
num_to_alphabet(_,Rem,Result) -> [num_to_alpha_list(Rem)|Result].

num_to_alpha_list(2) -> ["a","b","c"];
num_to_alpha_list(3) -> ["d","e","f"];
num_to_alpha_list(4) -> ["g","h","i"];
num_to_alpha_list(5) -> ["j","k","l"];
num_to_alpha_list(6) -> ["m","n","o"];
num_to_alpha_list(7) -> ["p","q","r","s"];
num_to_alpha_list(8) -> ["t","u","v"];
num_to_alpha_list(9) -> ["w","x","y","z"].

string_content([L1,L2,L3]) ->
  List = check_string([L1,L2,L3],{L2,L3},[]),
  {ok,FileDesc} = file:open("newdictionary.txt",read),
  match_with_file(List,read_content(FileDesc),FileDesc,[]).


match_with_file([],_,_,Results) ->Results;
match_with_file([String|Rest],String,_,Results) ->
  {ok,FileDesc} = file:open("newdictionary.txt",read),
  match_with_file(Rest,read_content(FileDesc),FileDesc,[String|Results]);
match_with_file([_|Rest],[],_,Results) ->
  {ok,FileDesc} = file:open("newdictionary.txt",read),
  match_with_file(Rest,read_content(FileDesc),FileDesc,Results);
match_with_file(Strings,_,Conn,Results) ->
  match_with_file(Strings,read_content(Conn),Conn,Results).


read_content(FileDescr) ->
  Value = io:get_line(FileDescr, '\n'),
  case is_list(Value) of
     true ->string:trim(Value);
     _ -> []
  end.

check_string([[Char1],[Char2],[Char3]],_,Res) -> [Char1++Char2++Char3 |Res];
check_string([[Char1,CharN|R1],[Char2],[Char3]],{B,C}=Clone,Res) -> check_string([[CharN|R1],B,C],Clone,[Char1++Char2++Char3 |Res]);
check_string([[Char1|R1],[Char2,CharN|R2],[Char3]],{_,C}=Clone,Res) -> check_string([[Char1|R1],[CharN|R2],C],Clone,[Char1++Char2++Char3 |Res]);
check_string([[Char1|R1],[Char2|R2],[Char3,CharN|R3]],Clone,Res) -> check_string([[Char1|R1],[Char2|R2],[CharN|R3]],Clone,[Char1++Char2++Char3 |Res]).


eff_file_create() ->
  {ok,FileDesc} = file:open("dictionary",read),
  {ok, FileWrite} = file:open("newdictionary.txt", [write]),
  Value = io:get_line(FileDesc, '\n'),
  enter_data(FileDesc,FileWrite,Value).




enter_data(_,_,eof) ->done;
enter_data(FileDesc,FileWrite,Value) ->
  NewString = string:lowercase(string:trim(Value)),
  write_or_not(NewString,FileDesc,FileWrite).

write_or_not(NewString,FileDesc,FileWrite) when length(NewString)=:=10 ; length(NewString) > 2 , length(NewString) =<  7 ->
  io:format(FileWrite,"~s~n",[NewString]),
  enter_data(FileDesc,FileWrite,io:get_line(FileDesc, '\n'));
write_or_not(_,FileDesc,FileWrite) ->
  enter_data(FileDesc,FileWrite,io:get_line(FileDesc, '\n')).

%% 176000 count decreased to 76000
%%  Hey decreased from 27 sec to 10 sec after eff_file_created


%% combo1 -> 10
%% combo2 -> 7,3
%% combo3 -> 3,7
%% combo4 -> 6,4
%% combo5 -> 4,6
%% combo6 -> 5,5
%% combo7 -> 4,3,3
%% combo8 -> 3,4,3
%% combo9 -> 3,3,4
