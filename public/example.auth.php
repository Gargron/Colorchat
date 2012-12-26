<?php

if($_SERVER['REQUEST_METHOD'] === 'POST') {
  if(!class_exists('Redis')) {
    throw new Exception("Please install the PHPRedis extension");
  }

  $name  = trim($_POST['name']);
  $email = trim($_POST['email']);
  $color = trim($_POST['color']);
  $nsfw  = trim($_POST['nsfw']);

  if(empty($name) || empty($email) || empty($color) || empty($nsfw)) {
    throw new Exception("Invalid input, this is an example script, please play by rules");
  }

  $redis = new Redis();
  $redis->connect('127.0.0.1');

  $newID      = $redis->incr('user:ids');
  $identifier = md5(uniqid());

  $user  = array(

    'id'    => (int) $newID,
    'name'  => $name,
    'email' => $email,
    'role'  => 1,
    'color' => $color,
    'nsfw'  => ($nsfw === 'true'),

  );

  $redis->setex('user:session:' . $identifier, 3600 * 6, json_encode($user));
  setcookie('auth', $identifier, time() + (3600 * 6));
}

?>

<!DOCTYPE html>

<?php if(isset($user)): ?>
  <strong>User created, cookie set. Go to the chat now!</strong>
<?php endif; ?>

<form action="" method="post">
  <label>Name: <input name="name"></label><br />
  <label>E-mail: <input name="email"></label><br />
  <label>HEX color: <input name="color"></label><br />

  <label><input type="radio" name="nsfw" value="true"> Show NSFW messages</label>
  <label><input type="radio" name="nsfw" value="false"> Hide NSFW messages</label>

  <button type="submit">Sign in</button>
</form>
