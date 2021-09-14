local reseau = {}


-- Librairies externes / Requires
local http = require("socket.http")
local ltn12 = require("ltn12")


-- Resultats qui contient la responses de la request HTTP de type GET qui contiendras le KeyBeta Officiel.
keyOfficiel = {}

-- Request HTTP - GET
local body, code, headers, status = http.request { 
    url = "http://crz-gamestudio.com/jeu/keyBeta.php", 
    method = "GET",
    sink = ltn12.sink.table(keyOfficiel)
}

-- Log status..
--print('code:' .. tostring(code))
--print('status:' .. tostring(status))

-- Print result for Request
keyOfficiel = table.concat(keyOfficiel)
--print(resultKeyOfficiel)


return reseau