local reseau = {}


-- Librairies externes / Requires
local http = require("socket.http")
local ltn12 = require("ltn12")


-- Resultat qui contient la responses de la request HTTP de type GET qui contiendras la clé d'accès pour jouer.
keyAccessOfficiel = {}

-- Request HTTP - GET
local body, code, headers, status = http.request { 
    url = "http://crz-gamestudio.com/jeu/keyBeta.php", 
    method = "GET",
    sink = ltn12.sink.table(keyAccessOfficiel)
}

-- Log status..
--print('code:' .. tostring(code))
--print('status:' .. tostring(status))

-- Print result for Request
keyAccessOfficiel = table.concat(keyAccessOfficiel)
--print(keyAccessOfficiel)


return reseau