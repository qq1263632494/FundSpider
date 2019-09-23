buy = ()->
    console.log '开始买笔'
    return new Promise (resolve, reject)->
        setTimeout ()->
            console.log '买了笔'
            resolve '数学作业'
        , 1000
work = (data)->
    console.log '开始写作业' + data
    return new Promise (resolve, reject)->
        setTimeout ()->
            console.log '写完作业'
            resolve '作业本'
        , 1000
out = (data)->
    console.log '开始上交' + data
    return new Promise (resolve, reject)->
        setTimeout ()->
            console.log '上交完毕'
            resolve '得分A'
        , 1000
buy().then work
    .then out
    .then (data)->
        console.log data
buy_aa = ()->
    console.log '开始买笔'
    return await setTimeout ()->
            console.log '买了笔'
            return '数学作业'
        , 1000
work_aa = ()->
    console.log '开始写作业' + await buy_aa()
    return await setTimeout ()->
            console.log '写完作业'
            return '作业本'
        , 1000
out_aa = ()->
    console.log '开始上交' + await work_aa()
    return await setTimeout ()->
            console.log '上交完毕'
            return '得分A'
        , 1000
run = ()->
    console.log await out_aa()
run()