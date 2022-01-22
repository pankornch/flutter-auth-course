import { Sequelize } from "sequelize"
import dotenv from "dotenv"

dotenv.config()

const {
	MYSQL_HOST,
	MYSQL_USERNAME,
	MYSQL_PASSWORD,
	MYSQL_DATABASE,
	MYSQL_PORT,
} = process.env

const conn = new Sequelize({
	host: MYSQL_HOST,
	username: MYSQL_USERNAME,
	password: MYSQL_PASSWORD,
	database: MYSQL_DATABASE,
	port: MYSQL_PORT,
	dialect: "mysql",
})

export default conn
