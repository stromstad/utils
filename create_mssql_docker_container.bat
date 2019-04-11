@echo off

IF "%1" == "" (
    echo "usage %0 <instance_name> <secure_password> [port [data directory]]"
    docker run --name mssql -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=WFgDlSTs8fZ6Qf0J7ivo" -e "MSSQL_PID=Express" --network mssql_network -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu
    goto end
)

IF "%2" == "" (
    docker run --name %1 -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=WFgDlSTs8fZ6Qf0J7ivo" -e "MSSQL_PID=Express" --network mssql_network -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu
    goto end

)

IF "%3" == "" (
    docker run --name %1 -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=%2" -e "MSSQL_PID=Express" --network mssql_network -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu
    goto end
)

IF "%4" == "" (
    docker run --name %1 -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=%2" -e "MSSQL_PID=Express" --network mssql_network -p %3:1433 -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu
    goto end
)

    docker run --name %1 -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=%2" -e "MSSQL_PID=Express" --network mssql_network -p %3:1433 -v %4:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu


:end