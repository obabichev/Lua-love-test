-- Object = require 'lib/classic/classic'
Object = require 'lib/classic/classic'

function love.load()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    circle = Circle:new(400, 300, 50)

end

function requireFiles(files)
    for _, file in ipairs(files) do
        print (file)
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
    love.graphics.print("Hello World", 400, 300)
    circle:draw()
end