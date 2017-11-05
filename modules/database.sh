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
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    sudo -u postgres dropuser --if-exists $USER
}

database_destroy()
{
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    dropdb --if-exists ark_${network}
}

database_create()
{
    if [ -z "$process_postgres" ]; then
        sudo service postgresql start
    fi

    sleep 1
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template0';" >&- 2>&-
    sudo -u postgres psql -c "update pg_database set encoding = 6, datcollate = 'en_US.UTF8', datctype = 'en_US.UTF8' where datname = 'template1';" >&- 2>&-
    sudo -u postgres psql -c "CREATE USER $USER WITH PASSWORD 'password' CREATEDB;" >&- 2>&-
    sleep 1
    createdb ark_${network}
}
