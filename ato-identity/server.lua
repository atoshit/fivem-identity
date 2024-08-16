---@class PlayerInfo
---@field firstname string
---@field lastname string
---@field dateofbirth string
---@field height number
---@field sex string

---@type table<string, PlayerInfo>
local registeringPlayers = {};

---@param playerId number
---@return string
local function getIdentifier(playerId)
    local identifier = GetPlayerIdentifierByType(playerId, 'license');
    return identifier and identifier:gsub('license:', '');
end

AddEventHandler('playerConnecting', function(name, skr, d)
    local playerId = source
    local identifier = getIdentifier(playerId);

    if (not identifier) then
        CancelEvent();
        return;
    end

    ---@param identifier string
    ---@param fields string[]
    local function queryPlayer(identifier, fields)
        local sql = 'SELECT ' .. table.concat(fields, ", ") .. ' FROM users WHERE identifier = @identifier'
        return MySQL.Sync.fetchAll(sql, { ['@identifier'] = identifier })
    end

    ---@param identifier string
    ---@return unknown
    local function isPlayerRegistered(identifier)
        return queryPlayer(identifier, { 'identifier' })[1] ~= nil
    end

    ---@param identifier string
    ---@return PlayerInfo
    local function getPlayerInfo(identifier)
        local result = queryPlayer(identifier, { 'firstname', 'lastname', 'dateofbirth', 'height', 'sex' })
        return result[1] or nil
    end

    ---@param playerInfo PlayerInfo
    ---@param errorMessage string
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
            addTextBlock('Sexe: ' .. (playerInfo.sex == 'm' and 'Homme' or 'Femme'))
        end

        d.presentCard(DeferralCards.Card.Create({ body = cardBody, actions = { DeferralCards.Action.Submit({ title = playerInfo and 'Se connecter' or 'Valider', style = 'positive' }) } }),
        function(data)
            if playerInfo then return d.done() end

            local function isValid(field, pattern, min, max)
                local value = tonumber(field)
                return field and (not pattern or field:match(pattern)) and (not min or value >= min) and (not max or value <= max)
            end

            if not (isValid(data.prenom, "^[%a ]+$") and isValid(data.nom, "^[%a ]+$") and isValid(data.date_naissance, "^%d%d%d%d%-%d%d%-%d%d$") and isValid(data.taille, nil, 150, 220) and data.sexe) then
                return showForm(nil, "Veuillez remplir correctement tous les champs.")
            end

            registeringPlayers[identifier] = {}
            registeringPlayers[identifier]['firstname'] = data.prenom
            registeringPlayers[identifier]['lastname'] = data.nom
            registeringPlayers[identifier]['dateofbirth'] = data.date_naissance
            registeringPlayers[identifier]['height'] = data.taille
            registeringPlayers[identifier]['sex'] = data.sexe

            d.done()
        end)
    end

    d.defer()
    Wait(1000)

    local playerInfo = getPlayerInfo(identifier)
    showForm(playerInfo)
end)

RegisterNetEvent('ato::RegisterPlayer', function ()
    local src = source;
    local identifier = getIdentifier(src);
    local playerInfo = registeringPlayers[identifier];

    if (not playerInfo) then return; end

    MySQL.Async.execute('UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, height = @height, sex = @sex WHERE identifier = @identifier', {
        ['@identifier'] = identifier,
        ['@firstname'] = playerInfo.firstname,
        ['@lastname'] = playerInfo.lastname,
        ['@dateofbirth'] = playerInfo.dateofbirth,
        ['@height'] = playerInfo.height,
        ['@sex'] = playerInfo.sex
    }, function()
        registeringPlayers[identifier] = nil;
    end)
    print('Identité enregistrée pour ' .. identifier);
end)
