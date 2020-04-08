console = require 'jass.console'
console.enable = true

runtime = require ("jass.runtime");
runtime.sleep = true;

common = require ("jass.common");

for i, v in pairs(common) do
    console.write(tostring(i));
end