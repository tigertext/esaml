%%%-------------------------------------------------------------------
%%% @author jonathanruttenberg
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jan 2022 11:06 AM
%%%-------------------------------------------------------------------
-module(esaml_dump_bytes).
-author("jonathanruttenberg").

%% API
-export([get_dump_url/0, set_dump_url/1, dump/1]).

get_dump_url() ->
  esaml:config(dump_url).

set_dump_url(Url) ->
  application:set_env(esaml, dump_url, Url).

dump(Bytes) ->
  case get_dump_url() of
    undefined ->
      ok;
    Url ->
%%      base64 encode the bytes
      Base64 = base64:encode(Bytes),

%%  send the encoded bytes
      case httpc:request(post, {Url, [], "application/octet-stream", Base64}, [], [{body_format, binary}]) of
        {ok, _Result} -> ok;
        {error, Reason} -> io:format("httpc:request error : ~p~n", Reason)
      end
  end.