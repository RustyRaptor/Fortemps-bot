import dimscord
import dimscmd
import dimscmd/interactionUtils
import asyncdispatch
import strutils
import options
import strscans
import strformat
import httpclient
import json

echo("Fortemps is loading!")

const token = "d33z-nut5"

let discord = newDiscordClient(token)
let client* = newAsyncHttpClient()
var cmd* = discord.newHandler()

proc interactionCreate (s: Shard, i: Interaction) {.event(discord).} =
    discard await cmd.handleInteraction(s, i)

# INIT MODULES HERE, TODO: MAKE THIS DYNAMIC LATER ON
include modules/profile

discord.events.on_ready = proc (s: Shard, r: Ready) {.async.} =
    echo "Ready as " & $r.user
    await cmd.registerCommands()
    echo "Registered Slash Commands!!"

waitFor discord.startSession()
