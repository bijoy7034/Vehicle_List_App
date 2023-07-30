const { default: mongoose } = require("mongoose");

const vehicleSchema = new mongoose.Schema({
    name : {
        type : String,
        required : true,
    },
    model : {
        type : String,
    },
    fuelEfficiency : {
        type : Number
    },
    age: {
        type: Number
    }
},
{timestamps:true})

module.exports = mongoose.model('VehicleSchema', vehicleSchema)