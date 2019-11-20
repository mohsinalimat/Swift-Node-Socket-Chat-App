const express = require('express')
const bodyparser = require('body-parser');
const db = require("./model/mongodb");

var app = express()
var http = require('http').Server(app)
var io = require('socket.io')(http)

const collection = "Messages";
const Users = "Users"

app.set('port',(process.env.PORT || 3000));
app.use(bodyparser.json())

//register
app.post('/register',(req,res,next) => {
  db.getDB().collection(Users).find({email:req.body.email}).toArray((err,items) => {
    if (items.length == 0){
      db.getDB().collection(Users).insertOne(req.body)
      res.status(201).send("創建成功");
    }else{
      res.status(404).send("已有存在Email");
    }
  })
})
//login
app.post('/login',(req,res,next) => {
  db.getDB().collection(Users).find({email:req.body.email}).toArray((err,items) => {
    if (items.length == 0){
      res.status(404).send("查無此帳號");
    }else{
      if (items[0].password === req.body.password){
        const user = [items[0]._id,items[0].name]
        res.status(201).send(user);
      }else{
        res.status(404).send("密碼錯誤");
      }
    }
  })
})
//SearchUsers
app.post('/search',(req,res,next) => {
  db.getDB().collection(Users).find({email:req.body.email}).toArray((err,items) => {
    if (items.length == 0){
      res.status(404).send("查詢不到任何猛漢");
    }else{
      const user = [items[0]._id,items[0].name]
      res.status(201).send(user);
    }
  })
})
//getUserMessage
app.post('/getMessageGroup',(req,res,next) => {
  db.getDB().collection(collection).find({UserID:req.body.uid}).toArray((err,items) => {
    if (items.length == 0){
      res.status(404).send("沒有新的聊天記錄");
    }else{
      //res.status(201).send(items);
      res.json(items[0])
    }
  })
})


db.connect((err)=>{

});

io.on('connection', async (socket)=>{
  //Messages save to mongoDB
  socket.on('new_msg',(data)=>{
    console.log(data)
    dbMessage(data.fromUid,data)
    dbMessage(data.toUid,data)
    socket.broadcast.emit(data.toUid,data)
  })
})

http.listen(app.get('port'),function() {

})

function dbMessage(uid,data) {
  db.getDB().collection(collection).find({UserID:uid}).toArray((err,items) => {
    if (items.length == 0){
      db.getDB().collection(collection).insertOne({UserID:uid,allMessage:[data]})
    }else{
      db.getDB().collection(collection).updateOne({UserID:uid},{$push:{allMessage:data}})
    }
  })
}
