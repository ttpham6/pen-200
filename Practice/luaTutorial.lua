-- https://lug.ncsu.edu/presentations/2018-02-14-lua.pdf


stringSample = 'stringA'
string2 = "stringB"

iNumber = 3
rNumber = 3.63
wholeNumber = 0
myBool = true
myBool = false

function callInto(x)
    print(x)
end




function foo()
    print("first")
    coroutine.yield() -- suspend thread
    print("third")
end


function bar()
    print("second")
    coroutine.yield()
    print("fourth")
end

function threadingSample()
    co1 = coroutine.create( foo )
    co2 = coroutine.create( bar )
    coroutine.resume(co1) -- first
    coroutine.resume(co2) -- second
    coroutine.resume(co1) -- third
    coroutine.resume(co2) -- forth    
end

function localVersusGlobal()
    local bar = 'this is local'
    baz = 'this is global'
    print (bar)
    print (baz)
end

function callingLVG()
    localVersusGlobal()
    print(bar)  -- "nil"  -- undefined
    print(baz)  -- "this is global"
end

function sampleTable()
    my_table = {
        stringA = 'asdf', -- Named keys
        1,  -- -name keys are automatically integers
        3,
        5
    }

    print( my_table.stringA ) -- "asdf"

    print( my_table['stringA'] ) -- also "asdf" (both ways work)
    print ( my_table['invalidString']) -- nil invalid string
    print( my_table[0] ) -- nil integers in table starts at 1    
    print( my_table[1] ) -- "1" (Note: tables start at 1 in Lua)
    print( my_table[2] ) -- "3"
    print( my_table[3] ) -- "5"
    -- print( my_table.1 ) -- Syntax error; not a string key
end



-- Calling functions
-- threadingSample()
-- callingLVG()
sampleTable()




-- Notable Aspects of Lua: Tables
-- Almost anything in Lua can act as a table key, even other tables

function TableExtended()
    tableX = {
        stringA = 'asdf', -- Named keys
        1,  -- -name keys are automatically integers
        3,
        5
    }
    function foo()
        end
    other_table = {
        [foo] = "function foo",
        ["1"] = "string 1", -- Different than numeric 1
        foo, -- Integer that references a function
        [true] = "true value",
        [tableX] = "my_table is the key",
    }
    print( other_table.foo ) -- "nil"
    print( other_table[foo] ) -- "function foo"
    print( other_table['1'] ) -- "string 1"
    print( other_table[1] ) -- "function: 0x......."
    print( other_table[true] ) -- "true value"
    print( other_table[tableX] ) -- "my_table is the key"

end

-- TableExtended()


function CyclicTable()
    cyclic1 = {}
    cyclic2 = {}
    cyclic1[1] = cyclic2
    cyclic2[1] = cyclic1
    print( cyclic1, cyclic2 ) -- table: a, table: b
    print( cyclic2[1], cyclic1[1] ) -- table: a, table: b
    print( cyclic1[1][1], cyclic2[1][1] ) -- table: a, table: b
    print( cyclic1[1][1][1], cyclic2[1][1][1]) -- table: a, table: b
end

-- CyclicTable()

--[[
-- Notable Aspects of Lua: Global Variable Table
-- All global variables are stored in a special table, “ G”
This table contains not only all global variables, but also all
base-library functions, such as print.
Using a table to store global variables allows for powerful
customizability through metamethods
]]
globalVariable = 'adsf'
print( _G.globalVariable ) -- 'asdf'

function add(x,y)
    return x+y
end

-- 


function CallAddition()
    local point = {}
    
    -- Create a new point 
    function point.new( x, y )
        return setmetatable( { x = x or 0, y = y or 0 }, point )
    end

    -- Invoked when addition occurs
    function point.__add( a, b )
        return point.new( a.x + b.x, a.y + b.y )
    end

    -- Invoked when table is called like a function
    function point:__call( x, y )
        return point.new( x, y )
    end
    
    -- Invoked when table is concatted
    function point:__tostring()
        -- Note implicit self (: vs . in function name)
        -- Is the same as point.__tostring( self, ... )
        return "( " .. tonumber( self.x ) .. ", "
        .. tonumber( self.y ) .. " )"
        end

    -- Applies metamethods; nothing special about table before this
    -- A table can have any table as its metatable, even itself
    setmetatable( point, point )
    local pointA = point()
    local pointB = point( 3, 3 )
    print( pointA ) -- table: 0x......
    
    print( pointA ) -- "( 0, 0 )"
    print( point.__tostring( pointA ) ) -- "( 0, 0 )"
    print( pointB ) -- "( 3, 3 )"
    local pointC = pointA + pointB
    print( pointC ) -- "( 3, 3 )"
    local pointD = point( -3, 4 )
    local pointE = pointC + pointD
    print( pointE ) -- "( 0, 7 )"

end

-- CallAddition()


function PreventAccidentalGlobals ()
        
    -- Using Metamethods to Prevent Accidental Globals
    declaredGlobals = {}
    function declare( name )
        declaredGlobals[name] = true
    end
    
    setmetatable( _G, {
    -- Called every time a new key is added to a table
    __newindex = function( tab, key, value )
    assert( declaredGlobals[key],
    "Error: value not declared"
    )
    -- Directly set the value
    -- (assigning would cause infinite loop)
    rawset( tab, key, value )
    end,
    } )
    foo = 3 -- Error: value not declared...
    declare( 'foo' )
    foo = 3
end

-- PreventAccidentalGlobals()


function TailCallSample()
    -- Improper tail call, as it's multiplying; not "just" tail call
    function factorial( n )
        if n == 0 then
            return 1
        else
            return n * fact( n - 1 )
        end  
    end

    -- factorial( -1 ) -- Stack overflow
    -- Proper tail call implementation of factorial
    function factorial( n, prod )
        prod = prod or 1
        if n == 0 then
            return prod
        else
            return factorial( n - 1, n * prod )
        end
    end

    factorial( -1 ) -- Infinite loop 
end

-- TailCallSample()




function FirstClassFunction()
    -- Notable Aspects of Lua: First-class functions
    -- Functions are ﬁrst-class values
    -- This basically means that functions can be used as arguments,
    -- return values, etc. Essentially, functions can be treated just like
    -- any variable.
    -- Consider the following example:
    local family = { "mom", "father", "sister", "son" }
    -- Note the "anonymous" function as a parameter
    table.sort( family, 
                function( string1, string2 )
                    return #string1 < #string2 -- # means "the length of"
                end )
    
    for i = 1, #family do
        print( family[i] )
    end
    -- "mom", "son", "sister", "father"

    -- local lines = {
    --     luaH_set = 10,
    --     luaH_get = 24,
    --     luaH_present = 48,
    --   }

    -- local a = {}
    -- for n in pairs(lines) do table.insert(a, n) end
    -- table.sort(a)
    -- for i,n in ipairs(a) do print(n) end

    -- function pairsByKeys (t, f)
    --     local a = {}
    --     for n in pairs(t) do table.insert(a, n) end
    --     table.sort(a, f)
    --     local i = 0      -- iterator variable
    --     local iter = function ()   -- iterator function
    --       i = i + 1
    --       if a[i] == nil then return nil
    --       else return a[i], t[a[i]]
    --       end
    --     end
    --     return iter
    --   end

    -- for name, line in pairsByKeys(lines) do
    -- print(name, line)
    -- end


end
    
FirstClassFunction()




-- https://www.lua.org/pil/6.1.html
-- Notable Aspects of Lua: Closures and Lexical scoping
-- A closure is a type of function with full access to its calling
-- environment. This environment is called its lexical scope.
function sortNames( names )
    table.sort( names, function( string1, string2 )
                        return #string1 < #string2 -- (# is "length of")
                        end 
                )
end
family = { "mom", "father", "sister", "son" }
sortNames( family )


for i = 1, #family do
print( family[i] )
end
-- "mom", "son", "father", "sister"
-- What type of value is names inside of the anonymous sorting
-- function? Is it local or global? 23



function newCounter()
    local i = 0
    return function()
        i = i + 1
        return i
    end
end
    
    
c1 = newCounter()
print( c1() ) -- "1"
print( c1() ) -- "2"


c2 = newCounter()
print( c2() ) -- "1"
print( c1() ) -- "3"




