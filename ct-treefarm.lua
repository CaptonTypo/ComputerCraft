term.clear()
term.setCursorPos(1,1)
print ("--------------------------------------")
print ("|            CT-TreeFarm             |")
print ("|                v1                  |")
print ("|          by: Captontypo            |")
print ("--------------------------------------")
print ()
print ("The farm will be created to the front and right of my current position.")
print ()
print ("Is this a new farm?(yes/no): ")
local isNew = read()

--How many rows of trees in the direction the turtle is currently facing.
print ("Length of farm? (Direction turtle is facing)")
local rowLength = tonumber(read())

--How many rows of trees to the left of the turtles current location.
print ("Width of farm? (To the left of the turtle)")
local rowWidth = tonumber(read())

--What slot the fuel is palced in. Must use logs of same wood type.
local fuelSlot = 16

--What slot your saplings are in.
local saplings = 15

--What slot your Ender Chest is in.
local chest = 14

--What slot your bordering material is in. Do NOT use logs of the same type as your trees.
local borderMaterial = 13

local name = os.getComputerLabel()

function openModem()
	if peripheral.getType("right") == "modem" then
		rednet.open("right")
		print ("Modem present and activated.")
		wifi = true
	else
		print ("No modem present.")
		wifi = false
	end
end

--Checks turtle's fuel level and refuels if need. Will display message on screen and broadcast to rednet of status.
function checkFuel()
	print ("Checking fuel.")
	while turtle.getFuelLevel() <= 100 do
		if turtle.getItemCount(fuelSlot) > 1 then
			turtle.select(fuelSlot)
			turtle.refuel(1)
			else
			print ("Error: Out of fuel!")
			if wifi == true then
				rednet.broadcast("Error("..name.."): Out of fuel!")
			end
			sleep(5)
		end
		sleep(0.1)
	end
end

function moveFwd()
	checkFuel()
	if turtle.forward() == false then
		repeat
			turtle.dig()
			sleep(0.3)
		until turtle.forward() == true		
	end
end

function removeTree()
	while turtle.detectUp() == true do
		repeat
			print ("removeTree - up")
			turtle.digUp()
			turtle.up()
		until turtle.detectUp() == false
		while turtle.detectDown() == false do
			repeat
				print ("removeTree - down")
				turtle.down()
			until turtle.detectDown() == true
			print ("removetree - dig down")
			turtle.digDown()
			plant()
		end
	end
end

--Plants a sapling. Will display on screen and broadcast to rednet if turtle is out of spalings.
function plant()
	print("Planting sapling.")
	turtle.select(saplings)
	if turtle.getItemCount(saplings) > 1 then
		if turtle.detectDown() == false then
			turtle.placeDown()
		else
			print("There is something already there.")
		end
	else
		while turtle.getItemCount(saplings) <= 1 do
			repeat
			print ("Error: Out of saplings!")
			if wifi == true then
				rednet.broadcast("Error("..name.."): Out of saplings!")
			end
			sleep(5)
			until turtle.getItemCount(saplings) > 1
		end
	end
end

function pickUp()
	turtle.select(saplings)
	turtle.suckDown()
end

function borderLength()
	print ("Placing border side length.")
	if rowLength % 2 == 0 then
		postCount = 0
	else
		postCount = 1
	end
	while postCount < rowLength do
		repeat
			if turtle.getItemCount(borderMaterial) >= 1 then
				print ("Placing post: "..postCount)
				moveFwd()
				turtle.select(borderMaterial)
				turtle.placeDown()
				postCount = postCount + 1			
			else
				print ("Error: Out of border supplies!")
				if wifi == true then
					rednet.broadcast("Error("..name.."): Out of border supplies!")
				end
				sleep(5)
			end
		until postCount == rowLength
	end
end

function borderWidth()
	print ("Placing border side width.")
	if rowWidth % 2 == 0 then
		postCount = 0
	else
		postCount = 1
	end
	while postCount < rowWidth do
		repeat
			if turtle.getItemCount(borderMaterial) >= 1 then
				checkFuel()
				print ("Placing post: "..postCount)
				moveFwd()
				turtle.select(borderMaterial)
				turtle.placeDown()
				postCount = postCount + 1
			else
				print ("Error: Out of border supplies!")
				if wifi == true then
					rednet.broadcast("Error("..name.."): Out of border supplies!")
				end
				sleep(5)
			end
		until postCount == rowWidth
	end
end

function buildBorder()
	print ("Building borders.")
	 for sideCount=1,2 do
	 	borderLength()
	 	turtle.turnLeft()
	 	borderWidth()
	 	turtle.turnLeft()
	 end
end

function depositLoot()
	print ("Depositing loot.")
	turtle.select(chest)
	if turtle.getItemCount(chest) == 1 then
		turtle.place()
		dropLoot()
		turtle.select(chest)
		turtle.dig()
	else
		print ("Error: Ender chest is missing.")
		if wifi == true then
			rednet.broadcast("Error("..name.."): Ender chest is missing.")
		end
		sleep(5)
	end
end

function dropLoot()
	print ("Droping loot in chest.")
	local dropItem = 1
	repeat
		turtle.select(dropItem)
		turtle.drop()
		dropItem = dropItem + 1
	until dropItem > 12
end

function processFillRow()
	print ("Processing fill row.")
	local lengthCount = rowLength - 3
	while lengthCount > 1 do
		repeat
			pickUp()
			if turtle.compare(turtle.select(fuelSlot)) == true then
				moveFwd()
				lengthCount = lengthCount - 1
				removeTree()
			else
				moveFwd()
				lengthCount = lengthCount - 1
			end
		until lengthCount == 0
	end
end

function processTreeRow()
	print ("Processing tree row.")
	local lengthCount = rowLength - 3
	while lengthCount > 1 do
		repeat
			pickUp()
			if turtle.compare(turtle.select(fuelSlot)) == true then
				moveFwd()
				lengthCount = lengthCount - 1
				removeTree()
			else
				moveFwd()
				lengthCount = lengthCount - 1
			end
			pickUp()
			if turtle.compare(turtle.select(fuelSlot)) == true then
				moveFwd()
				lengthCount = lengthCount - 1
				removeTree()
			else
				plant()
				moveFwd()
				lengthCount = lengthCount - 1
			end
		until lengthCount == 0
	end
end

function returnToStart()
	print ("Returning to starting position.")
	local toHome = rowWidth - 2
	turtle.back()
	turtle.turnRight()
	while toHome > 1 do
		repeat
			moveFwd()
			pickUp()
			toHome = toHome - 1
		until toHome == 0
	end
	turtle.turnLeft()
end

function new()
	print ("Starting new farm.")
	buildBorder()
	turtle.turnLeft()
 	moveFwd()
 	turtle.turnRight()
 	moveFwd()
 	returnToStart()
 	processAll()
end

function processAll()
	print ("Processing farm.")
	local widthCount = rowWidth - 3
	while widthCount > 1 do
		repeat
			processFillRow()
			turtle.turnLeft()
			moveFwd()
			widthCount = widthCount - 1
			turtle.turnLeft()
			processTreeRow()
			turtle.turnRight()
			if turtle.detect() == true then
				turtle.dig()
				depositLoot()
			else
				depositLoot()
			end
			moveFwd()
			widthCount = widthCount - 1
			turtle.turnRight()
		until widthCount == 0
	end
end

openModem()

if string.match(isNew, "yes") then
	print ("You said yes.")
	if wifi == true then
		rednet.broadcast(name..": Starting new tree farm.")
	end
	turtle.up()
	sleep(5)
	new()
else
	repeat
		print ("You said no.")
		if wifi == true then
			rednet.broadcast(name..": Starting processing of existing farm.")
		end
		turtle.turnLeft()
	 	moveFwd()
	 	turtle.turnRight()
		moveFwd()
		processAll()
		returnToStart()
		sleep(300)
	until true == false
end