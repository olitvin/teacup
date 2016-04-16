% Copyright 2016 Yuce Tekol <yucetekol@gmail.com>

% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at

%     http://www.apache.org/licenses/LICENSE-2.0

% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

-module(proxy@teacup).
-behaviour(teacup_server).

-export([teacup@signature/1,
         teacup@init/1,
         teacup@status/2,
         teacup@data/2,
         teacup@error/2]).

-define(MSG, ?MODULE).

teacup@signature(#{signature := Signature}) ->
    {ok, Signature};

teacup@signature(_) -> ok.

teacup@init(Opts) ->
    {ok, Opts}.

teacup@status(Status, State) ->
    notify_parent({teacup@status, Status}, State),
    {noreply, State}.

teacup@data(Data, State) ->
    notify_parent({teacup@data, Data}, State),
    {noreply, State}.

teacup@error(Reason, State) ->
    notify_parent({teacup@error, Reason}, State),
    {stop, Reason, State}.

notify_parent(Message, #{parent@ := Parent,
                         ref@ := Ref}) ->
    Parent ! {Ref, Message}.