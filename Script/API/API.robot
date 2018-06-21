*** Settings ***
Resource          ../Common/Public.robot

*** Keywords ***
Login
    [Arguments]    ${username}    ${password}    # 用户名 | 密码
    Log    API：用户登录
    ${header}    Create Dictionary    Content-Type    application/json
    Create Session    apiUrl    ${Url}    ${header}
    ${responses}    Post Request    apiUrl    /login?username=${username}&password=${password}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    ${customerId}    Get From Dictionary    ${data}    id
    Set Suite Variable    ${CustomerId}    ${customerId}

QueryBaseSchemaList
    Log    API：查询用户装修方案列表
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/query?customerId=${CustomerId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    ${baseSchema_0}    Get From List    ${data}    0
    Set Suite Variable    ${BaseSchemaId}    ${baseSchema_0['id']}
    Set Suite Variable    ${Data}    ${baseSchema_0}

QueryBaseSchemaSimInfo
    Log    API：查询基础装修方案简单信息
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

UpdateBaseSchema
    [Arguments]    ${houseId}    ${planeId}    ${colorId}    # 房id | 平面方案id | 色系id
    Log    API：更新基础装修方案
    ${header}    Create Dictionary    Content-Type    application/json
    ${requestBody}    Create Dictionary    houseId=${houseId}    planeId=${planeId}    colorId=${colorId}
    ${responses}    Put Request    apiUrl    /project/schema/${BaseSchemaId}    ${requestBody}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryCustomSchemaList
    Log    API：查询用户定制方案列表
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/customSchema?customerId=${CustomerId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    ${customSchema_0}    Get From List    ${data}    0
    Set Suite Variable    ${CustomSchemaId}    ${customSchema_0['id']}
    Set Suite Variable    ${Data}    ${customSchema_0}

QueryCusomSchemaSimInfoBasedSchema
    Log    API：查询基础方案对应的定制装修方案简单信息
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/customSchema    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryCustomSchemaSimInfo
    Log    API：查询指定定制装修方案简单信息
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/customSchema?customSchemaId=${CustomSchemaId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

UpdateCustomSchema
    [Arguments]    ${status}    #订单状态
    Log    API：更新定制装修方案
    ${header}    Create Dictionary    Content-Type    application/json
    ${requestBody}    Create Dictionary    status=${status}
    ${responses}    Put Request    apiUrl    /project/schema/${BaseSchemaId}/customSchema/${CustomSchemaId} ?status=${status}    ${requestBody}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryCustomSchemaResult
    Log    API：查询定制装修方案结果
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/customedComponent?customSchemaId=${CustomSchemaId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryAccessaryProComonent
    [Arguments]    ${productComponentId}    # 产品部品id
    Log    API：查询附属产品元素
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/accessory?productComponentId=${productComponentId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryCandidateProComponent
    [Arguments]    ${productComponentId}    # 产品部品id
    Log    API：查询可替换候选产品元素
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/accessory?productComponentId=${productComponentId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

AddCustomComponent
    [Arguments]    @{productComponentId}    # 产品部品id
    Log    API：添加定制选装元素
    ${header}    Create Dictionary    Content-Type    application/json
    ${requestBody}    Create Dictionary    productComponentIds=@{productComponentId}
    ${responses}    Post Request    apiUrl    /project/schema/${BaseSchemaId}/customComponent    ${requestBody}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryCustomSchemaComponentList
    Log    API：查询定制方案元素列表(购物车列表)
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/customSchemaComponent?isShowBase=true    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

DeleteCustomComponent
    [Arguments]    ${customedComponentId}    #装修方案产品元素id
    Log    API：删除装修方案元素
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Delete Request    apiUrl    /project/schema/${BaseSchemaId}/customedComponent/${customedComponentId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryCustomSchemaModuleInfo
    Log    API：查询定制装修方案模块下选择定制元素的数量
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/moduleCustomSummary    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryHouseInfo
    Log    API：查询房详情
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/house/${HouseId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryPlaneIdList
    Log    API：查询平面方案列表
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/house/${HouseId} /plane    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryStyleColorList
    [Arguments]    ${planeId}    # 平面方案id
    Log    API：查询平面方案下的风格色系列表
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/house/${HouseId} /color?planeId=${planeId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryModuleList
    Log    API：查询某个基础方案的模块列表
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/module    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryModuleComponent
    [Arguments]    ${moduleId}    # 模块id
    Log    API：查询模块元素
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/customComponent?moduleId=${moduleId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryBaseCompAccordCusomComp
    [Arguments]    ${productComponentId}    # 选配元素id
    Log    API：根据选配元素查标配的元素
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/baseComponent?productComponentId=${productComponentId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}

QueryBaseSchemaListAll
    [Arguments]    ${productComponentId}    # 选配元素id
    Log    API：批量获取标配列表
    ${header}    Create Dictionary    Content-Type    application/json
    ${responses}    Get Request    apiUrl    /project/schema/${BaseSchemaId}/baseComponents?productComponentId=${productComponentId}    headers=${header}
    Should Be Equal As Strings    ${responses.status_code}    200
    Log    ${responses.content}
    ${respjson}    To Json    ${responses.content}
    ${data}    Get From Dictionary    ${respjson}    data
    Set Suite Variable    ${Data}    ${data}
