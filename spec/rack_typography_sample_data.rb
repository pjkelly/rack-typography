module RackTypographySampleData

DIRTY_HTML = <<-dirty
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>OMG True Blood</title>
</head>
<body>
<p>Marley & Me.</p>
</body>
</html>
dirty

CLEAN_HTML = <<-clean
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>OMG True Blood</title>
</head>
<body>
<p>Marley &amp; Me.</p>
</body>
</html>
clean

end