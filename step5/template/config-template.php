<?php 

    $ip_address_static = getenv("STATIC_APP");
    $ip_address_dynamic = getenv("DYNAMIC_APP");
?>

<VirtualHost *:80>
   ServerName reverse.res.ch

   # Routes for api requests (random grades)
   ProxyPass '/api/' 'http://<?php print $ip_address_dynamic ?>/'
   ProxyPassReverse '/api/' 'http://<?php print $ip_address_dynamic ?>/'

   # Routes for static website
   ProxyPass '/' 'http://<?php print $ip_address_static ?>/'
   ProxyPassReverse '/' 'http://<?php print $ip_address_static ?>/'
</VirtualHost>