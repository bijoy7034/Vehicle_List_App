const express = require('express');
const dotenv = require('dotenv');
const { default: mongoose } = require('mongoose');
const router = require('./Routes/vehicleRoutes');

dotenv.config()

const app = express()
const PORT = process.env.PORT || 8000
const url = process.env.MONGO_URL

app.use(express.json());
app.use((req, res, next) => {
    console.log(req.path, req.method);
    next();
  });
app.use('/api/vehicles', router)

mongoose.connect(url) 
.then(()=>{
    app.listen(PORT, ()=>{
        console.log(`SERVER IS RUNNING ON ${PORT}`)
    })
})
.catch((err)=>{
    console.log(err)
})

