<?php 
    $statics_nodes = getenv("STATIC_APP");
    $dynamic_nodes = getenv("DYNAMIC_APP");

    $staticsTokens = explode (',', $statics_nodes);
    $dynamicsTokens = explode (',', $dynamic_nodes);
?>

<VirtualHost *:80>
   ServerName reverse.res.ch

   # Routes for api requests (random grades)
   <Proxy 'balancer://dynamic_cluster'>
   		<?php 
   			foreach($dynamicsTokens as $server)
   			{
				echo('BalancerMember "' . 'http://' . $server . '"' . "\n");
   			}
   		?>
	</Proxy>
   	ProxyPass '/api/' 'balancer://dynamic_cluster'
   	ProxyPassReverse '/api/' 'balancer://dynamic_cluster'

   # Routes for static website
   <Proxy 'balancer://static_cluster'>
	    <?php 
   			foreach($staticsTokens as $server)
   			{
				echo('BalancerMember "' . 'http://' . $server . '"' . "\n");
   			}
   		?>
	</Proxy>
   	ProxyPass '/' 'balancer://static_cluster'
   	ProxyPassReverse '/' 'balancer://static_cluster'
</VirtualHost>