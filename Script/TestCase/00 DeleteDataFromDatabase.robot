*** Settings ***
Resource          ../API/API.robot

*** Test Cases ***
DeleteData（清理测试数据）
    Connect To Database Using Custom Params    pymysql    host='172.16.248.190',port=3306,user='admin',passwd='admin',db='bh_platform'
    Execute Sql Script    E:/BimHouse_Test/Platform_Test/SQLScript.sql
    Disconnect From Database
