import asyncdispatch
import httpclient
import json
import options
import os
import strformat, strutils

import dimscord
import dimscmd
import dimscmd/interactionUtils

echo("Fortemps is loading!")

# Load config here

if fileExists("config.json") == false:
    echo("Enter Discord API Key")
    var discordToken: string = readLine(stdin)
    echo("Enter XIVAPI Private key")
    var xivapiToken: string = readLine(stdin)
    echo("Enter Guild ID")
    var guildId = readLine(stdin)

    let config_json = %*
        {
        "discord_token": discordToken,
        "xivapi_token": xivapiToken,
        "guild_id": guildId
        }

    writeFile("config.json", $config_json)

var config: JsonNode = readFile("config.json").parseJson()

if config{"discord_token"}.isNil or config{"xivapi_token"}.isNil or config{"guild_id"}.isNil:
    echo("ERROR: Something is wrong with your config file. Try deleting it and run the program again to initialize it.")
    quit(1)

var
    token: string = config{"discord_token"}.getStr()
    apiToken: string = config{"xivapi_token"}.getStr()
    gid: string = config{"guild_id"}.getStr()

let discord = newDiscordClient(token)
let client = newAsyncHttpClient()
var cmd = discord.newHandler()

proc interactionCreate (s: Shard, i: Interaction) {.event(discord).} =
    discard await cmd.handleInteraction(s, i)

# INIT MODULES HERE, TODO: MAKE THIS DYNAMIC LATER ON
include modules/profile

discord.events.on_ready = proc (s: Shard, r: Ready) {.async.} =
    echo "Ready as " & $r.user
    await cmd.registerCommands()
    echo "Registered Slash Commands!!"

waitFor discord.startSession()