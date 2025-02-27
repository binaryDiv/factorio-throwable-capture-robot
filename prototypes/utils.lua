local utils = {
    settings = {},
    technologies = {},
    recipes = {},
}

-- Get the value of a mod startup setting (name will be automatically prefixed with mod name)
function utils.settings.get(name)
    return settings.startup["throwable-capture-robot-" .. name].value
end

-- Get setting whether the capture robot rocket should be removed
function utils.settings.get_replace_rocket()
    return utils.settings.get("replace-rocket")
end

-- Add an effect to unlock a recipe to a technology. If no position is given, the effect will be appended.
function utils.technologies.add_recipe(technology_name, new_recipe, position)
    local technology = data.raw["technology"][technology_name]

    -- Append if no position is specified
    if position == nil then
        position = #technology.effects + 1
    end

    -- Insert new effect at the given position
    table.insert(
        technology.effects,
        position,
        {
            type = "unlock-recipe",
            recipe = new_recipe,
        }
    )
end

-- Replace a recipe unlocked by a technology with a different one
function utils.technologies.replace_recipe(technology_name, old_recipe, new_recipe)
    local technology = data.raw["technology"][technology_name]

    for _, effect in pairs(technology.effects) do
        if effect.type == "unlock-recipe" and effect.recipe == old_recipe then
            effect.recipe = new_recipe
        end
    end
end

-- Remove a prerequisite from a technology
function utils.technologies.remove_prerequisite(technology_name, prerequisite)
    local technology = data.raw["technology"][technology_name]

    for index, entry in pairs(technology.prerequisites) do
        if entry == prerequisite then
            table.remove(technology.prerequisites, index)
            return
        end
    end
end

-- Replace an ingredient with another one in *all* recipes
function utils.recipes.replace_ingredient_in_all_recipes(old_ingredient, new_ingredient)
    for _, recipe in pairs(data.raw["recipe"]) do
        if recipe.ingredients ~= nil then
            for _, ingredient in pairs(recipe.ingredients) do
                if ingredient.type == "item" and ingredient.name == old_ingredient then
                    ingredient.name = new_ingredient
                end
            end
        end
    end
end

return utils
