# TODO: Clean up code

cmd.addSlash("profile", guildID = &"{gid}") do (server: string, firstname: string, surname: string):
    ## Grabs FFXIV basic details
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

    else:
        var
            user_id = first_result["ID"]
            profile_url = fmt"https://xivapi.com/character/{user_id}?private_key={api_token}"
            content = waitFor client.getContent(profile_url)
            parsed_json = content.parseJson()
            character = parsed_json["Character"]
            active_class_job = character["ActiveClassJob"]
            unlocked_state = active_class_job["UnlockedState"]
            char_name = character["Name"].getStr()
            portrait_url = character["Portrait"].getStr()
            level = active_class_job["Level"].getInt()
            job_name = unlocked_state["Name"].getStr()
            desc_string = fmt"Level **{level} {job_name}**"

        embed = Embed(
            title: some(char_name),
            description: some(desc_string),
            image: some(EmbedImage(url: some(portrait_url)))
        )

    await discord.api.editWebhookMessage(s.user.id, i.token, "@original", embeds = @[embed])