up:
	php artisan serve

down:
	php artisan down

fresh:
	php artisan migrate:fresh
	php artisan db:seed

optimize:
	php artisan cache:clear
	php artisan optimize:clear

models:
	php artisan ide-helper:model
	php artisan ide-helper:eloquent
