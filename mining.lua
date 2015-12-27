local tArgs = { ... }

local function move_forward(length)
   if length == 0 then
      return
   end

   for i=1,length do
      if turtle.detect() then
         turtle.dig()
      end
      turtle.forward()
   end
end

local function move_backward(length)
   if length == 0 then
      return
   end

   turtle.turnRight(); turtle.turnRight()
   for i=1,length do
      if turtle.detect() then
         turtle.dig()
      end
      turtle.forward()
   end
   turtle.turnRight(); turtle.turnRight()
end

local function move_right(length)
   if length == 0 then
      return
   end

   turtle.turnRight()
   for i=1,length do
      if turtle.detect() then
         turtle.dig()
      end
      turtle.forward()
   end
   turtle.turnLeft()
end

local function move_left(length)
   if length == 0 then
      return
   end

   turtle.turnLeft()
   for i=1,length do
      if turtle.detect() then
         turtle.dig()
      end
      turtle.forward()
   end
   turtle.turnRight()
end

local function dirt_slot()
   local cobblestone_name = "minecraft:cobblestone"
   local dirt_name = "minecraft:dirt"
   data = turtle.getItemDetail()
   if data then
      if data.name == cobblestone_name then
         return true
      elseif data.name == dirt_name then
         return true
      else
         return false
      end
   else
      return false
   end
end

local function get_dirt_slot()
   local cobblestone_name = "minecraft:cobblestone"
   local dirt_name = "minecraft:dirt"
   for i=1,16 do
      turtle.select(i)
      if dirt_slot() then
         return i
      end
   end
   return 0
end

local function dropItems()
   for i=1,16 do
      turtle.select(i)
      turtle.drop()
   end
   turtle.select(1)
end

local function dig(front, right, current_height, fill_height)
   print("Digging in ", front, " ", right)

   print("First layer not touched!")

   for i=0,front-1 do
      for j=0,right-1 do

         print("X: ", i, ", Y: ",j)
         local y = 0

         -- move to horizontal position
         move_forward(i)
         move_right(j)

         -- do the digging
         while true do
            if turtle.detectDown() then
               if turtle.digDown() then
                  turtle.down()
               else
                  break
               end
            else
               turtle.down()
            end
            y = y + 1
         end

         -- back to original height
         for i=y,1,-1 do
            turtle.up()
            local stone_slot = get_dirt_slot()
            if stone_slot ~= 0 then
               if i > (current_height - fill_height) then
                  print("placing block at height: ", i)
                  turtle.select(stone_slot)
                  turtle.placeDown()
               end
            end
         end

         -- back to original horizontal position.
         move_left(j)
         move_backward(i)

         -- drop items into chest.
         turtle.turnRight(); turtle.turnRight()
         dropItems()
         turtle.turnRight(); turtle.turnRight()
      end
   end
end

local function usage()
   print("Usage: mining.lua action front right")
   print("       Actions could be [dig]")
end

local function main()
   if #tArgs < 5 then
      print("Not enough arguments!")
      usage()
      return
   elseif #tArgs > 5 then
      print("Too much arguments!")
      usage()
      return
   else
      action = tArgs[1]
      front = tArgs[2]
      right = tArgs[3]
      current_height = tArgs[4]
      fill_to = tArgs[5]
      if action == "dig" then
         dig(front, right, current_height, fill_to)
      else
         print("Action not recognized, allowed actions are [dig].")
         return
      end
   end
end


main()
