const express = require('express');
const vehicleModel = require('../Models/vehicleModel');
const router = express.Router()

router.get('/', async (req,res)=>{
    try{
        const vehicle = await vehicleModel.find({})
        
        if(!vehicle) return res.status(400).json({ mssg: "Error in fetching" });

        return   res.status(200).json(vehicle);
    }catch(err){
        res.status(400).json({error : err.message})
    }
})
router.post('/create', async (req,res)=>{

    try{
        const name = req.body.name
        const model = req.body.model
        const fuelEfficiency = req.body.fuelEfficiency
        const age = req.body.age

        const vehicle = await vehicleModel.create({name, model, fuelEfficiency, age})

        if(!vehicle) return res.status(400).json({ mssg: "Creation failed" });

        return res.status(200).json(vehicle);
    
    }catch(err){
        res.status(400).json({error : err.message})
    }
})

module.exports  = router