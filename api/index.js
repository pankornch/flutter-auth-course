import express from "express"
import cors from "cors"
import sequelize from "./src/configs/db"
import router from "./src/routes"
const app = express()

app.use(cors("*"))
app.use(express.json())

const PORT = 5050

app.use(router)

app.get("/test", (req, res) => {
	res.send("Hello World!")
})

const startServer = async () => {
	await sequelize.sync({ force: false })

	app.listen(PORT, () => {
		console.log(`Server is running on http://localhost:${PORT}`)
	})
}

startServer()
