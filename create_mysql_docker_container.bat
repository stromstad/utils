@ECHO off

IF "%2" == "" (
    echo "usage %0 <instance_name> <root_password> <port> [network_name] [data_dir_path]"
    echo "Run docker network create <network_name> before this if using custom network"

    goto end
)

IF "%4" == "" (
    docker run --name %1 -e MYSQL_ROOT_PASSWORD=%2 -p %3:3306 -d mysql
    goto end
)

IF "%5" == "" (
    docker run --name %1 -e MYSQL_ROOT_PASSWORD=%2 -p %3:3306 --network %4 -d mysql
    goto end
)

docker run --name %1 -e MYSQL_ROOT_PASSWORD=%2 -p %3:3306 --network %4 -v %5:/var/lib/mysql -d mysql

:end