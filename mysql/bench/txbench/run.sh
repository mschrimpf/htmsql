javac *.java

#SibenchClient MPL R-WEIGHT RU-WEIGHT ISOLATION-LEVEL
java -Dconfigure=./config.txt -cp .:./mysql-connector-java-5.1.11-bin.jar SibenchClient 10 75 25 S2PL
