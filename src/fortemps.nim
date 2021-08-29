import asyncdispatch
import httpclient
import options
import os
import strutils, strformat
import json

import dimscord
import dimscmd
import dimscmd/interactionUtils

echo("Fortemps is loading!")

var 
    file: TaintedString
    config: JsonNode 
    token: string
    api_token: string
    gid: string
# Load config here

if fileExists("config.json") == false:
    echo("Enter Discord API Key")
    var discord_token = readLine(stdin)
    echo("Enter XIVAPI Private key")
    var xivapi_token = readLine(stdin)
    echo("Enter Guild ID")
    var guild_id = readLine(stdin)
    let config_json = %*{"discord_token": discord_token, "xivapi_token": xivapi_token, "guild_id": guild_id}
    writeFile("config.json", $config_json)

try:
    file = readFile("config.json")
    config = file.parseJson()
    token = config["discord_token"].getStr()
    api_token = config["xivapi_token"].getStr()
    gid = config["guild_id"].getStr()
except:
    echo("ERROR: Something is wrong with your config file. Try deleting it and run the program again to initialize it.")
    quit(1)

echo(token)
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