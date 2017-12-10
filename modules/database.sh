#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of noah.
#
# (c) Brian Faust <hello@brianfaust.me>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

database_drop_user()
{
    sudo -u postgres dropuser --if-exists $USER >> $noah_log 2>&1
}

database_destroy()
{
    sudo -u postgres dropdb --if-exists ark_${network} >> $noah_log 2>&1
}

database_create()
{
    sleep 1
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template0';" >> $noah_log 2>&1
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template1';" >> $noah_log 2>&1
    sudo -u postgres psql -c "CREATE USER $USER WITH PASSWORD 'password' CREATEDB;" >> $noah_log 2>&1
    sleep 1
    createdb ark_${network}
}

database_close()
{
    sudo -u postgres psql -c "SELECT pid, pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'ark_${network}' AND pid <> pg_backend_pid();"
}

database_start()
{
    sudo service postgresql start
}

database_stop()
{
    sudo service postgresql stop
}

database_restart()
{
    sudo service postgresql restart
}
