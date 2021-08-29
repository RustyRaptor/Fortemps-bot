# TODO: Checks Character levels use XIVAPI

# This part seems standard enough to be brought to it's own function for searching a profile using strings

#[ cmd.addSlash("levels", guildID = &"{gid}") do (server: string, firstname: string, surname: string):
    ## Grabs character levels

    await discord.api.createInteractionResponse(i.id, i.token, 
        InteractionResponse(
            kind: irtDeferredChannelMessageWithSource
        )
    )

    var
        search_url = fmt"https://xivapi.com/character/search?name={firstname.strip()}%20{surname.strip()}&server={server.strip()}&private_key={api_token}"
        search_content = waitFor client.getContent(search_url)
        search_parsed_json = search_content.parseJson()
        results = search_parsed_json["Results"]
        first_result = results{0}

    var embed: Embed

    if first_result.isNil:
        embed = Embed(
            title: some("ERROR!"),
            description: some("Character/Server not found!"),
        )
    ]#
