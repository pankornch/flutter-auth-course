import { DataTypes } from "sequelize"
import mysql from "../configs/mysql"

const Todo = mysql.define("todos", {
	name: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	user_id: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	completed: {
		type: DataTypes.BOOLEAN,
		defaultValue: false,
	},
})

export default Todo
