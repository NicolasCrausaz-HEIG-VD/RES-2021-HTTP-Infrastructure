<?php 
    $statics_nodes = getenv("STATIC_APP");
    $dynamic_nodes = getenv("DYNAMIC_APP");

    $staticsTokens = explode (',', $statics_nodes);
    $dynamicsTokens = explode (',', $dynamic_nodes);
?>

<VirtualHost *:80>
   ServerName reverse.res.ch

   # Routes for api requests (random grades)
	Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED
   <Proxy 'balancer://dynamic_cluster'>
   		<?php 
   			foreach($dynamicsTokens as $i => $server)
   			{
					echo('BalancerMember "' . 'http://' . $server . '"' . ' route=' . ($i + 1) . "\n");
   			}
   		?>
		ProxySet stickysession=ROUTEID
	</Proxy>

   # Routes for static website
   <Proxy 'balancer://static_cluster'>
	    <?php 
   			foreach($staticsTokens as $i => $server)
   			{
					echo('BalancerMember "' . 'http://' . $server . '"' . ' route=' . ($i + 1) . "\n");
   			}
   		?>
		ProxySet stickysession=ROUTEID
	</Proxy>

	ProxyPass '/api/' 'balancer://dynamic_cluster/' stickysession=ROUTEID|jsessionid scolonpathdelim=On
	ProxyPassReverse '/api/' 'balancer://dynamic_cluster/'

	ProxyPass '/' 'balancer://static_cluster/' stickysession=ROUTEID|jsessionid scolonpathdelim=On
	ProxyPassReverse '/' 'balancer://static_cluster/'
</VirtualHost>
