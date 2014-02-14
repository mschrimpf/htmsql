# Install script for directory: /home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "1")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/bin/dbt-plot-iostat;/bin/dbt-plot-mpstat;/bin/dbt-plot-transaction-distribution;/bin/dbt-plot-vmstat;/bin/dbt-pgsql-plot-database-stats;/bin/dbt-pgsql-plot-index-stats;/bin/dbt-pgsql-plot-table-stats")
  IF (CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  ENDIF (CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
  IF (CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  ENDIF (CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
FILE(INSTALL DESTINATION "/bin" TYPE PROGRAM FILES
    "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/bin/dbt-plot-iostat"
    "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/bin/dbt-plot-mpstat"
    "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/bin/dbt-plot-transaction-distribution"
    "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/bin/dbt-plot-vmstat"
    "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/bin/pgsql/dbt-pgsql-plot-database-stats"
    "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/bin/pgsql/dbt-pgsql-plot-index-stats"
    "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/bin/pgsql/dbt-pgsql-plot-table-stats"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
ELSE(CMAKE_INSTALL_COMPONENT)
  SET(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
ENDIF(CMAKE_INSTALL_COMPONENT)

FILE(WRITE "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/${CMAKE_INSTALL_MANIFEST}" "")
FOREACH(file ${CMAKE_INSTALL_MANIFEST_FILES})
  FILE(APPEND "/home/htmsql/develop/mysql/dbt2-0.37.50.3/dbttools/${CMAKE_INSTALL_MANIFEST}" "${file}\n")
ENDFOREACH(file)
