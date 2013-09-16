term.clear()
term.setCursorPos(1,1)
 
print ("Checking if sides are clear...")
 
while turtle.detectUp() == false do
    repeat
        if turtle.detect() == false then
			term.setCursorPos(1,2)
			print ("This side clear.     ")
			redstone.setOutput("left", false)
			redstone.setOutput("right", false)
			sleep(1)
			else
			term.setCursorPos(1,2)
			print ("This side blocked.")
			redstone.setOutput("left", true)
			redstone.setOutput("right", true)
			sleep(1)
        end
    until turtle.detectUp() == true
end