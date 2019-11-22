# Swift-Node-Socket-Chat-App

### iOS Socket

- **Edit**  TableMessageController.swift , SearchUserController.swift , ChatViewController.swift
```swift
let manager = SocketManager(socketURL: URL(string: "https://xxxxxx.herokuapp.com")!, config: [ .compress])
```

### MongoDB

- **Edit** mongodb.js
```javascript
const url = "mongodb://<name>:<password>@cluster0-shard-00-00-fyamy.gcp.mongodb.net:27017,cluster0-shard-00-01-fyamy.gcp.mongodb.net:27017,cluster0-shard-00-02-fyamy.gcp.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority";
```

### Deploy

1. Run `npm install` to install server dependencies.

2. Run `node index` to start the development server.

3. Deploy to Heroku.

### iOS

-  Run `pod install` to install.

<img src="https://matt-bucket-images.s3-ap-southeast-1.amazonaws.com/Simulator+Screen+Shot+-+iPhone+11+-+2019-11-20+at+18.46.29.png
" width="250" height="520"/> <img src="https://matt-bucket-images.s3-ap-southeast-1.amazonaws.com/Simulator+Screen+Shot+-+iPhone+11+Pro+-+2019-11-20+at+18.46.46.png
" width="250" height="520"/>
