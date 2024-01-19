::ROOT <- getroottable();
if (!("ConstantNamingConvention" in ROOT)) // make sure folding is only done once
{
	foreach (a,b in Constants)
		foreach (k,v in b)
			if (v == null)
				ROOT[k] <- 0;
			else
				ROOT[k] <- v;
}

foreach (k, v in NetProps.getclass())
    if (k != "IsValid")
		ROOT[k] <- NetProps[k].bindenv(NetProps);

::eventProxy <- "tf_map_time_remaining";
::value <- 0;
::hud_text <- SpawnEntityFromTable("game_text", { targetname = "gametext" });
ClearGameEventCallbacks();

enum PROTOCOL
{
	VScript_SentByValue,
	VScript_SentByRef,
	SM_SentByValue,
	SM_SentByRef,
	SM_ReceiveByRef,
}

RegisterScriptGameEventListener(eventProxy);

::eventFuncTable <- {};
::eventRefTable <- {};

::Test <- function()
{
	SendSourcemodGameEvent(eventProxy,
	{
		func = "TestFunc",
		test = "Failed",
		protocol = PROTOCOL.VScript_SentByRef
	});
}

function OnGameEvent_tf_map_time_remaining(params)
{
	switch(params.protocol)
	{
		case PROTOCOL.VScript_SentByRef:
			{
				eventRefTable = params;
				break;
			}
		case PROTOCOL.SM_SentByRef:
			{
				EventReceivedHandler(params);
				params.protocol = PROTOCOL.SM_ReceiveByRef;
				SendSourcemodGameEvent(eventProxy, params);
				break;
			}
		default:
			{
				params = {}
			}
	}
}

function SendSourcemodGameEvent(event, params)
{
	eventRefTable.clear();
	SendGlobalGameEvent(event, params);
}

function EventReceivedHandler(params)
{
	if (params.func in eventFuncTable)
	{
		eventFuncTable[params.func](params);
	}
}

eventFuncTable.SendMercVOToSM <- function(params)
{
	params["playsnd"] = false;
}

::DoTest <- function()
{
	local params =
	{
		func = "CacheMercVOPreference"
		player_index = PlayerInstanceFromIndex(1).entindex()
		play_merc_vo = false
		protocol = PROTOCOL.VScript_SentByValue
	};

	SendSourcemodGameEvent(eventProxy, params);
}

__CollectGameEventCallbacks(this);
__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);