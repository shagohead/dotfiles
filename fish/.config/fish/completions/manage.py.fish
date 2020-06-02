set -l django_commands changepassword createsuperuser remove_stale_contenttypes \
check compilemessages createcachetable dbshell diffsettings dumpdata flush inspectdb loaddata \
makemessages makemigrations migrate sendtestemail shell showmigrations sqlflush sqlmigrate \
sqlsequencereset squashmigrations startapp startproject test testserver clearsessions \
collectstatic findstatic runserver
complete -c manage.py -f -a (string join " " $django_commands)
