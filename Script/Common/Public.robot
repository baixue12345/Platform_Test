*** Settings ***
Library           RequestsLibrary
Library           Selenium2Library
Library           requests
Library           Collections
Library           json
Library           OperatingSystem
Library           DatabaseLibrary

*** Variables ***
${Url}            http://172.16.248.192    # 访问地址
${Username}       13525253434    # 用户名
${Password}       123456    # 密码
${CustomerId}     ${EMPTY}    # 用户id
${BaseSchemaId}    ${EMPTY}    # 基础装修方案id
${CustomSchemaId}    ${EMPTY}    # 定制装修方案id
${Data}           ${EMPTY}    # 接口返回的data值
${ProductComponentId}    5600698779249292    # 产品部品id
${HouseId}        \    #房id
