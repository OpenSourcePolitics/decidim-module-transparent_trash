extends:
	grep -R "path:" lib/decidim/transparent_trash/extends | awk '{print $$4}'
