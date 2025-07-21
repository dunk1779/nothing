local SaveManager = {} do
    SaveManager.Folder = 'LinoriaLibSettings'
    SaveManager.SubFolder = ''
    SaveManager.Ignore = {}
    SaveManager.Library = nil
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object)
                return { type = 'Toggle', idx = idx, value = object.Value }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Toggles[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = 'Slider', idx = idx, value = tostring(object.Value) }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.value then
                    object:SetValue(data.value)
                end
            end,
        },
        ColorPicker = {
            Save = function(idx, object)
                return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    SaveManager.Library.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
                end
            end,
        },
        KeyPicker = {
            Save = function(idx, object)
                -- Convert the Enum.KeyCode object to its string representation for saving
                return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = tostring(object.Value) }
            end,
            Load = function(idx, data)
                if SaveManager.Library.Options[idx] then
                    -- Convert the string back to Enum.KeyCode if necessary, otherwise use as is.
                    -- Assuming data.key will be something like "Enum.KeyCode.F"
                    local key = data.key
                    if string.find(key, "Enum.KeyCode.") then
                        local enumName = string.sub(key, string.len("Enum.KeyCode.") + 1)
                        key = Enum.KeyCode[enumName]
                    end
                    SaveManager.Library.Options[idx]:SetValue({ key, data.mode })
                end
            end,
        },
        Input = {
            Save = function(idx, object)
                return { type = 'Input', idx = idx, text = object.Value }
            end,
            Load = function(idx, data)
                local object = SaveManager.Library.Options[idx]
                if object and object.Value ~= data.text and type(data.text) == 'string' then
                    SaveManager.Library.Options[idx]:SetValue(data.text)
                end
            end,
        },
    }
