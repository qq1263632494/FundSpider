function getpath(fpath) {
    return new Promise(function (resolve) {
        fs.readFile(fpath, function (err, dataStr) {
            if (err) throw err;
            console.log(dataStr);
            resolve(dataStr)
        })
    })
}

//这是正确的
getpath("./test.txt").then(function (data) { //这是执行成功
    console.log(data)
}).catch(function (err) {
    console.log("err.message")
});
//另外将then中的回调函数写成一个函数的话 可以直接在then()调用函数的名称而不加小括号如下示例：
//例2    写作业
function buy() {
    console.log("开始买笔");
    var p = new Promise(function (resolve, reject) {
        setTimeout(function () {
            console.log("买了笔芯");
            resolve("数学作业");
        }, 1000);
    });
    return p;
}

function work(data) {
    console.log("开始写作业：" + data);
    var p = new Promise(function (resolve, reject) {
        setTimeout(function () {
            console.log("写完作业");
            resolve("作业本");
        }, 1000);
    });
    return p;
}

function out(data) {
    console.log("开始上交：" + data);
    var p = new Promise(function (resolve, reject) {
        setTimeout(function () {
            console.log("上交完毕");
            resolve("得分：A");
        }, 1000);
    });
    return p;
}

/* 不建议使用这种方式
buy().then(function(data){
    return work(data);
}).then(function(data){
    return out(data);
}).then(function(data){
    console.log(data);
});*/

//推荐这种简化的写法
buy().then(work).then(out).then(function (data) {  // 直接写函数的名称
    console.log(data);
});

