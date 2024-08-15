local DeferralCards = {
    Card = {},
    CardElement = {},
    Container = {},
    Action = {},
    Input = {}
}

exports('DeferralCards', function()
    return DeferralCards
end)

--------------------------------------------------[[ Cards ]]--------------------------------------------------

function DeferralCards.Card.Create(pOptions)
    if not pOptions then return end
    pOptions.type = 'AdaptiveCard'
    pOptions.version = pOptions.version or '1.4'
    pOptions.body = pOptions.body or {}
    pOptions['$schema'] = 'http://adaptivecards.io/schemas/adaptive-card.json'
    return json.encode(pOptions)
end

--------------------------------------------------[[ Card Elements ]]--------------------------------------------------

function DeferralCards.CardElement.TextBlock(pOptions)
    if not pOptions then return end
    pOptions.type = 'TextBlock'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end

function DeferralCards.CardElement.Image(pOptions)
    if not pOptions then return end
    pOptions.type = 'Image'
    pOptions.url = pOptions.url or 'https://via.placeholder.com/100x100?text=Temp+Image'
    return pOptions
end

function DeferralCards.CardElement.Media(pOptions)
    if not pOptions then return end
    pOptions.type = 'Media'
    pOptions.sources = pOptions.sources or {}
    return pOptions
end

function DeferralCards.CardElement.RichTextBlockItem(pOptions)
    if not pOptions then return end
    pOptions.type = 'TextRun'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end

function DeferralCards.CardElement.RichTextBlock(pOptions)
    if not pOptions then return end
    pOptions.type = 'RichTextBlock'
    pOptions.inline = pOptions.inline or {}
    return pOptions
end

function DeferralCards.CardElement.TextRun(pOptions)
    if not pOptions then return end
    pOptions.type = 'TextRun'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end

--------------------------------------------------[[ Containers ]]--------------------------------------------------

function DeferralCards.Container.Create(pOptions)
    if not pOptions then return end
    pOptions.type = 'Container'
    pOptions.items = pOptions.items or {}
    return pOptions
end

function DeferralCards.Container.ActionSet(pOptions)
    if not pOptions then return end
    pOptions.type = 'ActionSet'
    pOptions.actions = pOptions.actions or {}
    return pOptions
end

function DeferralCards.Container.ColumnSet(pOptions)
    if not pOptions then return end
    pOptions.type = 'ColumnSet'
    pOptions.columns = pOptions.columns or {}
    return pOptions
end

function DeferralCards.Container.Column(pOptions)
    if not pOptions then return end
    pOptions.type = 'Column'
    pOptions.items = pOptions.items or {}
    return pOptions
end

function DeferralCards.Container.Fact(pOptions)
    if not pOptions then return end
    pOptions.title = pOptions.title or 'Title'
    pOptions.value = pOptions.value or 'Value'
    return pOptions
end

function DeferralCards.Container.FactSet(pOptions)
    if not pOptions then return end
    pOptions.type = 'FactSet'
    pOptions.facts = pOptions.facts or {}
    return pOptions
end

function DeferralCards.Container.ImageSetItem(pOptions)
    if not pOptions then return end
    pOptions.type = pOptions.type or 'Image'
    pOptions.url = pOptions.url or 'https://adaptivecards.io/content/cats/1.png'
    return pOptions
end

function DeferralCards.Container.ImageSet(pOptions)
    if not pOptions then return end
    pOptions.type = 'ImageSet'
    pOptions.images = pOptions.images or {}
    return pOptions
end

--------------------------------------------------[[ Actions ]]--------------------------------------------------

function DeferralCards.Action.OpenUrl(pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.OpenUrl'
    pOptions.url = pOptions.url or 'https://www.google.co.uk/'
    return pOptions
end

function DeferralCards.Action.Submit(pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.Submit'
    return pOptions
end

function DeferralCards.Action.ShowCard(pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.ShowCard'
    return pOptions
end

function DeferralCards.Action.TargetElement(pOptions)
    if not pOptions then return end
    pOptions.elementId = pOptions.elementId or 'target_element'
    return pOptions
end

function DeferralCards.Action.ToggleVisibility(pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.ToggleVisibility'
    pOptions.targetElements = pOptions.targetElements or {}
    return pOptions
end

function DeferralCards.Action.Execute(pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.Execute'
    return pOptions
end

--------------------------------------------------[[ Inputs ]]--------------------------------------------------

function DeferralCards.Input.Text(pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Text'
    pOptions.id = pOptions.id or 'input_text'
    return pOptions
end

function DeferralCards.Input.Number(pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Number'
    pOptions.id = pOptions.id or 'input_number'
    return pOptions
end

function DeferralCards.Input.Date(pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Date'
    pOptions.id = pOptions.id or 'input_date'
    return pOptions
end

function DeferralCards.Input.Time(pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Time'
    pOptions.id = pOptions.id or 'input_time'
    return pOptions
end

function DeferralCards.Input.Toggle(pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Toggle'
    pOptions.title = pOptions.title or 'Title'
    pOptions.id = pOptions.id or 'input_toggle'
    return pOptions
end

function DeferralCards.Input.Choice(pOptions)
    if not pOptions then return end
    pOptions.title = pOptions.title or 'Title'
    pOptions.value = pOptions.value or 'Value'
    return pOptions
end

function DeferralCards.Input.ChoiceSet(pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.ChoiceSet'
    pOptions.choices = pOptions.choices or {}
    pOptions.id = pOptions.id or 'choice_set'
    return pOptions
end

