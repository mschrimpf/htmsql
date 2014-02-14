CMAKE_MINIMUM_REQUIRED(VERSION 2.4)
PROJECT(DBTTOOLS)

#
# Install rules.
#

INSTALL(PROGRAMS 
        bin/dbt-plot-iostat
        bin/dbt-plot-mpstat
        bin/dbt-plot-transaction-distribution
        bin/dbt-plot-vmstat
        bin/pgsql/dbt-pgsql-plot-database-stats
        bin/pgsql/dbt-pgsql-plot-index-stats
        bin/pgsql/dbt-pgsql-plot-table-stats
        DESTINATION "/bin")
