# TODO: Clean up code

cmd.addSlash("profile", guildID = &"{gid}") do (server: string, firstname: string, surname: string):
    ## Grabs FFXIV basic details
    await discord.api.createInteractionResponse(i.id, i.token, 
        InteractionResponse(
            kind: irtDeferredChannelMessageWithSource
        )
    )
    var embed: Embed

    try:
        var
            searchUrl = fmt"https://ffxiv-character-cards.herokuapp.com/prepare/name/{server.strip()}/{firstname.strip()}%20{surname.strip()}"
            searchContent = waitFor client.getContent(searchUrl)
            image = searchContent.parseJson(){"url"}

        embed = Embed(
            image: some(EmbedImage(url: some(fmt"https://ffxiv-character-cards.herokuapp.com{image.getStr()}")))
        )

        await discord.api.editWebhookMessage(s.user.id, i.token, "@original", embeds = @[embed])
        

    except:
        embed = Embed(
                title: some("ERROR!"),
                description: some("Character/Server not found!"),
            )
        await discord.api.editWebhookMessage(s.user.id, i.token, "@original", embeds = @[embed])

    # Repurpose this code later

    # var
    #     searchUrl = fmt"https://xivapi.com/character/search?name={firstname.strip()}%20{surname.strip()}&server={server.strip()}&private_key={apiToken}"
    #     searchContent = waitFor client.getContent(searchUrl)
    #     result = searchContent.parseJson()["Results"]{0}

    # var embed: Embed

    # if result.isNil:
    #     embed = Embed(
    #         title: some("ERROR!"),
    #         description: some("Character/Server not found!"),
    #     )

    # else:
    #     var
    #         userId = result["ID"]
    #         profile_url = fmt"https://xivapi.com/character/{userId}?private_key={apiToken}"
    #         content = waitFor client.getContent(profile_url)
    #         character = content.parseJson()["Character"]
    #         charName: string = character["Name"].getStr()
    #         portraitUrl: string = character["Portrait"].getStr()
    #         activeClassJob: JsonNode = character["ActiveClassJob"]
    #         level = activeClassJob["Level"].getInt()
    #         jobName = activeClassJob["UnlockedState"]["Name"].getStr()
    #         descString = fmt"Level **{level} {jobName}**"

    #     embed = Embed(
    #         title: some(charName),
    #         description: some(descString),
    #         image: some(EmbedImage(url: some(portraitUrl)))
    #     )
    