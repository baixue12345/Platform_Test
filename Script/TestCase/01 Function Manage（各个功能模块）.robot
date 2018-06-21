*** Settings ***
Resource          ../API/API.robot

*** Test Cases ***
001 Schema Controller（基础装修方案管理）
    #思路：登录-查询用户装修方案列表-查询基础装修方案简单信息-更新基础装修方案
    Login    ${Username}    ${Password}    #用户登录
    QueryBaseSchemaList    #查询用户装修方案列表
    ${houseId}    Get From Dictionary    ${Data}    houseId
    Set Suite Variable    ${houseId}    ${HouseId}
    ${planeId}    Get From Dictionary    ${Data}    planeId
    ${planeName}    Get From Dictionary    ${Data}    planeName
    ${colorId}    Get From Dictionary    ${Data}    colorId
    ${colorName}    Get From Dictionary    ${Data}    colorName
    QueryBaseSchemaSimInfo    #查询基础装修方案简单信息
    ${planeName}    Get From Dictionary    ${Data}    planeName
    ${colorName}    Get From Dictionary    ${Data}    colorName
    QueryStyleColorList    ${planeId}    #查询平面方案下的风格色系列表
    ${styleColorNumber}    Get Length    ${Data}
    : FOR    ${i}    IN RANGE    ${styleColorNumber}
    \    Log    风格色系Id：${Data[${i}]['id']}、风格色系名称：${Data[${i}]['title']}
    ${styleColor_0}    Get From List    ${Data}    0
    ${styleColorId}    Get From Dictionary    ${styleColor_0}    id
    UpdateBaseSchema    ${houseId}    ${planeId}    ${styleColorId}    #更新基础装修方案
    ${planeName}    Get From Dictionary    ${Data}    planeName
    ${colorName}    Get From Dictionary    ${Data}    colorName

002 Custom Schema Controller（定制装修方案管理）
    #思路：
    Comment    QueryCustomSchemaList    #查询用户定制方案列表
    QueryCusomSchemaSimInfoBasedSchema    #查询基础方案对应的定制装修方案简单信息
    QueryCustomSchemaSimInfo    #查询指定定制装修方案简单信息
    UpdateCustomSchema    0    #更新定制装修方案
    QueryCustomSchemaResult    #查询定制装修方案结果

003 Schema Component Controller（定制装修方案部品管理）
    #思路
    QueryAccessaryProComonent    2510064785478270    #查询附属产品元素
    ${accessory}    Get From Dictionary    ${Data}    components
    ${accessoryNumber}    Get Length    ${accessory}
    AddCustomComponent    ${ProductComponentId}    #添加定制选装元素
    ${addCustoms}    Get From Dictionary    ${Data}    addCustoms
    ${addCustoms_0}    Get From List    ${addCustoms}    0
    ${productComponentId}    Get From Dictionary    ${addCustoms_0}    id
    QueryCustomSchemaComponentList    #查询定制方案元素列表(购物车列表)
    DeleteCustomComponent    ${productComponentId}    #删除装修方案元素
    QueryCustomSchemaModuleInfo    #查询定制装修方案模块下选择定制元素的数量

004 House Controller（房管理）
    #思路
    QueryHouseInfo    #查询房详情
    QueryPlaneIdList    #查询平面方案列表
    ${planeNumber}    Get Length    ${Data}
    : FOR    ${i}    IN RANGE    ${planeNumber}
    \    Log    平面方案Id：${Data[${i}]['id']}、平面方案名称：${Data[${i}]['title']}
    ${plane_0}    Get From List    ${Data}    0
    ${planeId}    Get From Dictionary    ${plane_0}    id
    QueryStyleColorList    ${planeId}    #查询平面方案下的风格色系列表
    ${styleColorNumber}    Get Length    ${Data}
    : FOR    ${i}    IN RANGE    ${styleColorNumber}
    \    Log    风格色系Id：${Data[${i}]['id']}、风格色系名称：${Data[${i}]['title']}

005 Product Component Controller（标配以及维度）
    #思路：
    QueryModuleList    #查询某个基础方案的模块列表
    ${moduleNumber}    Get Length    ${Data}
    : FOR    ${i}    IN RANGE    ${moduleNumber}
    \    Log    模块Id：${Data[${i}]['id']}、模块名称：${Data[${i}]['name']}
    ${module_0}    Get From List    ${Data}    0
    ${moduleId}    Get From Dictionary    ${module_0}    id
    QueryModuleComponent    ${moduleId}    #查询模块元素
    ${components}    Get From Dictionary    ${Data}    components
    ${componentsNumber}    Get Length    ${components}
    QueryBaseCompAccordCusomComp    ${ProductComponentId}    #根据选配元素查标配的元素
    QueryBaseSchemaListAll    ${ProductComponentId}    #批量获取标配列表

*** Keywords ***
