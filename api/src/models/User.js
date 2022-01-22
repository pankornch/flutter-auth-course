import { DataTypes } from "sequelize"
import mysql from "../configs/mysql"

const User = mysql.define("users", {
	username: {
		type: DataTypes.STRING,
		unique: true,
		allowNull: false,
	},
	password: {
		type: DataTypes.STRING,
		allowNull: false,
	},
})

export default User
