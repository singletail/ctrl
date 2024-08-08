local _, ctrl = ...

local settings = {
    name = 'template',
    color = ctrl.c.c,
    symbol = ctrl.s.template,
}

ctrl.template = ctrl.mod:new(settings)

function ctrl.template:loadTemplateItem(sectionName, itemData)
    if itemData.template then
        local presetName = itemData.template
        if not ctrl.templates[sectionName][presetName] then
            error('No such preset', presetName)
            return
        end
        local overrides = ctrl.safecopy(itemData)
        overrides.preset = nil
        ctrl.safeset(itemData, ctrl.templates[sectionName][presetName], 5, nil)
        ctrl.safeset(itemData, overrides, 5, nil)
    end
end

function ctrl.template:get(name)
    if not ctrl.templates.ux[name] then
        error('No such template', 2)
        return
    end
    local templateCopy = ctrl.safecopy(ctrl.templates.ux[name], 10)

    for sectionName, sectionData in pairs(templateCopy) do
        if sectionName == 'frame' then
            self:loadTemplateItem(sectionName, templateCopy[sectionName]) --sectionData)
        else
            for itemName, itemData in pairs(sectionData) do
                self:loadTemplateItem(sectionName, templateCopy[sectionName][itemName]) --itemData)
            end
        end
    end

    return templateCopy
end
