*** Settings ***
Resource          ../API/API.robot

*** Test Cases ***
001 Login（登录）
    Login    ${Username}    ${Password}    #用户登录

002 Custom Schema Card（定制方案卡片页）
    QueryBaseSchemaList    #查询用户装修方案列表
    ${houseId}    Get From Dictionary    ${Data}    houseId
    Set Suite Variable    ${houseId}    ${HouseId}
    QueryBaseSchemaSimInfo    #查询基础装修方案简单信息
    ${planeName}    Get From Dictionary    ${Data}    planeName
    ${colorName}    Get From Dictionary    ${Data}    colorName
    QueryCustomSchemaModuleInfo    #查询定制装修方案模块下选择定制元素的数量
    ${moduleNumber}    Get Length    ${Data}
    : FOR    ${i}    IN RANGE    ${moduleNumber}
    \    Log    模块名称：${Data[${i}]['moduleName']}、部品数量：${Data[${i}]['num']}

003 Base Schema（基础定制）
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
    ${styleColor_0}    Get From List    ${Data}    0
    ${styleColorId}    Get From Dictionary    ${styleColor_0}    id
    UpdateBaseSchema    ${HouseId}    ${planeId}    ${styleColorId}    #更新基础装修方案
    ${planeName}    Get From Dictionary    ${Data}    planeName
    ${colorName}    Get From Dictionary    ${Data}    colorName

004 Custom Schema（选装定制）
    QueryModuleList    #查询某个基础方案的模块列表
    ${moduleNumber}    Get Length    ${Data}
    : FOR    ${i}    IN RANGE    ${moduleNumber}
    \    Log    模块Id：${Data[${i}]['id']}、模块名称：${Data[${i}]['name']}
    ${module}    Get From List    ${Data}    2    #模块：功能收纳
    ${moduleId}    Get From Dictionary    ${module}    id
    ${modulename}    Get From Dictionary    ${module}    name
    QueryModuleComponent    ${moduleId}    #查询模块元素
    ${components}    Get From Dictionary    ${Data}    components
    ${componentsNumber}    Get Length    ${components}
    : FOR    ${i}    IN RANGE    ${componentsNumber}
    \    Log    部品Id：${components[${i}]['id']}、部品名称：${components[${i}]['name']}
    ${component_0}    Get From List    ${components}    0    #南卧室衣柜
    ${componentId_0}    Get From Dictionary    ${component_0}    id
    ${componentname_0}    Get From Dictionary    ${component_0}    name
    ${price_0}    Get From Dictionary    ${component_0}    priceSpread    #部品价格
    ${component_6}    Get From List    ${components}    6    #主卧衣柜一 商务型-实木皮
    ${componentId_6}    Get From Dictionary    ${component_6}    id
    ${componentname_6}    Get From Dictionary    ${component_6}    name
    ${price_6}    Get From Dictionary    ${component_6}    priceSpread    #部品价格
    Set Suite Variable    ${ProductComponentId}    ${componentId_6}
    AddCustomComponent    ${componentId_0}    #添加加配部品到购物车    #南卧室衣柜
    ${addCustoms}    Get From Dictionary    ${Data}    addCustoms
    ${addCustoms_0}    Get From List    ${addCustoms}    0
    ${productComponentId}    Get From Dictionary    ${addCustoms_0}    id
    ${totalAmount}    Get From Dictionary    ${Data}    totalAmount
    Should Be Equal As Numbers    ${totalAmount}    ${price_0}
    AddCustomComponent    ${componentId_6}    #添加升级部品到购物车    #主卧衣柜一 商务型-实木皮
    ${totalAmount}    Get From Dictionary    ${Data}    totalAmount
    Run Keyword If    ${totalAmount}==${price_0}+${price_6}    Log    Pass
    QueryAccessaryProComonent    ${componentId_6}    #查询附属产品元素
    ${components}    Get From Dictionary    ${Data}    components
    ${componentsNumber}    Get Length    ${components}
    : FOR    ${i}    IN RANGE    ${componentsNumber}
    \    Log    部品Id：${components[${i}]['id']}、部品名称：${components[${i}]['name']}
    ${component_0}    Get From List    ${components}    0    #主卧衣柜一密码抽
    ${componentId}    Get From Dictionary    ${component_0}    id
    ${componentname}    Get From Dictionary    ${component_0}    name
    ${price}    Get From Dictionary    ${component_0}    priceSpread    #部品价格
    AddCustomComponent    ${componentId_6}    ${componentId}    #添加柜子配件到购物车    #主卧衣柜一密码抽
    ${totalAmount}    Get From Dictionary    ${Data}    totalAmount
    Run Keyword If    ${totalAmount}==${price_0}+${price_6}+${price}    Log    Pass
    QueryCustomSchemaComponentList    #查询定制方案元素列表(购物车列表)
    ${addComponents}    Get From Dictionary    ${Data}    addCustoms
    ${addNumber}    Get Length    ${addComponents}
    ${totalAmount}    Get From Dictionary    ${Data}    totalAmount
    Run Keyword If    ${totalAmount}==${price_0}+${price_6}+${price}    Log    Pass    #校验购物车部品价格
    Should Be Equal As Numbers    ${addNumber}    3    \    #校验购物车部品数量
    DeleteCustomComponent    ${productComponentId}    #删除上面添加的加配部品    #南卧室衣柜
    ${totalAmount}    Get From Dictionary    ${Data}    totalAmount
    QueryCustomSchemaComponentList    #查询定制方案元素列表(购物车列表)
    ${addComponents_0}    Get From Dictionary    ${Data}    addCustoms
    ${addNumber_0}    Get Length    ${addComponents_0}
    ${totalAmount}    Get From Dictionary    ${Data}    totalAmount
    Run Keyword If    ${totalAmount}==${price_6}+${price}    Log    Pass    #校验购物车部品价格
    Run Keyword If    ${addNumber}-${addNumber_0}==1    Log    Pass    #校验购物车部品数量
    QueryCustomSchemaList    #查询用户定制方案列表
    UpdateCustomSchema    2    #更新定制装修方案

005 Custom List（定制清单）
    QueryCustomSchemaResult    #查询定制装修方案结果
    ${amount}    Get From Dictionary    ${Data}    amount
    QueryCusomSchemaSimInfoBasedSchema    #查询基础方案对应的定制装修方案简单信息
    QueryCustomSchemaSimInfo    #查询指定定制装修方案简单信息
    QueryBaseCompAccordCusomComp    ${ProductComponentId}    #根据选配元素查标配的元素
