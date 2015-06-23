@echo off
find "nic_drivernames" < nic_dete.inc > nic_dete.tmp
e nic_dete.tmp
del nic_dete.tmp
