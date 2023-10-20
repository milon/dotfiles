#!/bin/zsh

brew install composer
composer global require laravel/valet
composer global require tightenco/takeout:~2.0
composer global require psy/psysh

echo 'XX -- Composer done.'
