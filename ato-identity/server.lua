DeferralCards = exports['ato-identity']:DeferralCards()

AddEventHandler('playerConnecting', function(name, skr, d)
    local playerId = source
    playerIdentifier = nil

    for _, identifier in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(identifier, 1, 8) == "license:" then
            playerIdentifier = string.gsub(identifier, "license:", "")
            break
        end
    end 

    local function queryPlayer(identifier, fields)
        local sql = 'SELECT ' .. table.concat(fields, ", ") .. ' FROM users WHERE identifier = @identifier'
        return MySQL.Sync.fetchAll(sql, { ['@identifier'] = identifier })
    end

    local function isPlayerRegistered(identifier)
        return queryPlayer(identifier, { 'identifier' })[1] ~= nil
    end

    local function getPlayerInfo(identifier)
        local result = queryPlayer(identifier, { 'firstname', 'lastname', 'dateofbirth', 'height', 'sex' })
        return result[1] or nil
    end

    local function showForm(playerInfo, errorMessage)
        local cardBody = {}
        local addTextBlock = function(text, size, color)
            table.insert(cardBody, DeferralCards.CardElement.TextBlock({
                text = text, size = size or 'Default', weight = 'Bolder', color = color or 'default'
            }))
        end

        if errorMessage then addTextBlock(errorMessage, 'Medium', 'attention') end
        if not playerInfo then
            addTextBlock("Veuillez créer l'identité de votre personnage:", 'Large', 'accent')
            table.insert(cardBody, DeferralCards.Input.Text({ id = 'prenom', placeholder = 'Entrez votre prénom (ex: Jean)', title = 'Prénom' }))
            table.insert(cardBody, DeferralCards.Input.Text({ id = 'nom', placeholder = 'Entrez votre nom (ex: Dupont)', title = 'Nom' }))
            table.insert(cardBody, DeferralCards.Input.Date({ id = 'date_naissance', placeholder = 'AAAA-MM-JJ', title = 'Date de Naissance' }))
            table.insert(cardBody, DeferralCards.Input.Number({ id = 'taille', placeholder = 'Entrez votre taille en cm (ex: 175)', title = 'Taille (cm)' }))
            table.insert(cardBody, DeferralCards.Input.ChoiceSet({
                id = 'sexe', title = 'Sexe',
                choices = {
                    DeferralCards.Input.Choice({ title = 'Homme', value = 'homme' }),
                    DeferralCards.Input.Choice({ title = 'Femme', value = 'femme' })
                }
            }))
        else
            addTextBlock('Informations sur votre personnage:', 'Large', 'accent')
            addTextBlock('Prénom: ' .. playerInfo.firstname)
            addTextBlock('Nom: ' .. playerInfo.lastname)
            addTextBlock('Date de naissance: ' .. playerInfo.dateofbirth)
            addTextBlock('Taille: ' .. playerInfo.height .. ' cm')
            addTextBlock('Sexe: ' .. (playerInfo.sex == 'h' and 'Homme' or 'Femme'))
        end

        d.presentCard(DeferralCards.Card.Create({ body = cardBody, actions = { DeferralCards.Action.Submit({ title = playerInfo and 'Se connecter' or 'Valider', style = 'positive' }) } }), 
        function(data)
            if playerInfo then return d.done() end

            local function isValid(field, pattern, min, max)
                local value = tonumber(field)
                return field and (not pattern or field:match(pattern)) and (not min or value >= min) and (not max or value <= max)
            end

            prenom, nom, date_naissance, taille, sex = data.prenom, data.nom, data.date_naissance, data.taille, data.sexe
            if not (isValid(prenom, "^[%a ]+$") and isValid(nom, "^[%a ]+$") and isValid(date_naissance, "^%d%d%d%d%-%d%d%-%d%d$") and isValid(taille, nil, 150, 220) and sex) then
                return showForm(nil, "Veuillez remplir correctement tous les champs.")
            end

            registerPlayer = true
            d.done()
        end)
    end

    d.defer()
    Wait(1000)

    local playerInfo = getPlayerInfo(playerIdentifier)
    showForm(playerInfo)
end)

RegisterNetEvent('ato::RegisterPlayer', function ()
    if registerPlayer then
        MySQL.Async.execute('UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, height = @height, sex = @sex WHERE identifier = @identifier', {
            ['@identifier'] = playerIdentifier,
            ['@firstname'] = prenom,
            ['@lastname'] = nom,
            ['@dateofbirth'] = date_naissance,
            ['@height'] = taille,
            ['@sex'] = sex
        })
        print('Identité enregistrée pour ' .. playerIdentifier)
    end
end)