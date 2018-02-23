Object = require 'lib/classic/classic'
Input = require 'lib/boipushy/input'

function love.load()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    circle = HyperCircle(400, 300, 50, 10, 120)
end

function requireFiles(files)
    for _, file in ipairs(files) do
        print(file)
        local file = file:sub(1, -5)
        require(file)
    end
end

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

function love.draw()
    circle:draw()
end

function love.keypressed(key)
    print("main.lua<love.keypressed> key: " .. key)
end

function love.keyreleased(key)
    print("main.lua<love.keyreleased> key: " .. key)
end

function love.mousepressed(x, y, button)
    print("main.lua<love.mousepressed> button: " .. button)
end

function love.mousereleased(x, y, button)
    print("main.lua<love.mousereleased> button: " .. button)
end