const Medicine = require("../models/MedicineModel");
const Pharmacy = require("../models/pharmacyModel");
const Inventory = require("../models/inventoryModel");
const customError = require('../utils/customError');

exports.searchMedicine = async ({
  medicineName,
}) => {
  // Find the medicine by name using a case-insensitive search
  const medicine = await Medicine.findOne({
    name: { $regex: medicineName, $options: "i" },
  });

  if (!medicine) {
    throw new customError('Medicine not found.', 400);
  }

  
  let inventoryItems = await Inventory.find({ medicine: medicine._id,}).populate("pharmacy");
 
  console.log("🚀 ~ inventoryItems:", inventoryItems)
  // Transform results for response
  const result = inventoryItems
    .filter(item => item.pharmacy) // Only include items with a valid pharmacy
    .map((item) => ({
      pharmacyName: item.pharmacy.name,
      address: item.pharmacy.address,
      photo: item.pharmacy.pharmacyImage,
      price: item.price,
      quantity: item.quantity,
      latitude: item.pharmacy.latitude,
      longitude: item.pharmacy.longitude,
      pharmacyId: item.pharmacy._id,
      inventoryId: item._id,
    }));
  return result
};

 