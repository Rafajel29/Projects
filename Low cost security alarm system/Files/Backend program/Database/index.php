<pre>
<?php
$db = mysqli_connect("127.0.0.1","root","","demo") or die(mysqli_error($db))

print_r($_GET)
mysqli_close($db)
?>
</pre>