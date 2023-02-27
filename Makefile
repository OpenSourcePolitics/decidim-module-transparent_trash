extends:
	grep -R "# path:" lib/decidim/transparent_trash/extends | awk '{print $$4}'

overrides:
	grep -R "# Override" app -A 4 | grep "# path:" | awk '{print $$3}'
