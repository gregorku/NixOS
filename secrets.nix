let
  serverVPStest = "age1ws5gtnuuamhksc8urq7rzekw3mrs968all0vkpvukc06dc4q7v0q7q58jr";  # sem vlož výstup
in
{
  "serverVPStest/test-secret.age".publicKeys = [ serverVPStest ];
}