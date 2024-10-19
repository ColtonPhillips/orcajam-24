# Check if the profile file exists; if not, create it
# LETS GET CREATIVE!
if (-not (Test-Path $PROFILE)) { 
    New-Item -Path $PROFILE -ItemType File -Force 
}

# Chase Your Bliss
$burns=@'

$burns=@"
:lllc::;;;;;;;;;;;;;;,,;;;;;;;;;;;;;;;;;;;,,,,;;:c
:ll;.              .';::::;,.                   .;
:lc.             'cdkOkOOOOkdc;;;'.             .;
:lc.           .:kOkkkkkkkkkkxdllo:.            .,
:l:.           :kOkkkkkkkkkxxkolllo;            .,
:l:.          .oOkkkkkkkkkkxkxolclo;            .,
:l:.          .cxxxxxxxxxdkxxxollol.            .;
:l:.           .oxddxxxOOOOkxkxl,..             .;
:l:.            ,dxxkkxxxxddookd.               .;
:l:.           ,okxoxkkkkxd;..ckl....           .;
:l;.          ;kdoxxkkxo;'''.;dkxooddc.         .;
:l;.         .::.:xol:'.  .:dddxdxkkxx:         .:
:l;              ..        'xxodxkxdxOo.        .:
:l,                       .lxxdxkxoxkOl.        .:
:l,                     .coddxkkxodkOx'         .:
:l,                    .cxxxkkxdodxOx;          'c
:l;.                   .dkkxxdoooxkx:.          ;c
:lc:,,''',,,,,,,,,,,,,,;lllccccccccc;,,,,,,,,,,;cc
:cccllllllllllllllllllllllccclcccccclccllllllllcl:
"@

echo $burns
echo "Hello Smithers. You're quite good at turning me on."
'@

Add-Content -Path $PROFILE -Value $burns

echo $burns