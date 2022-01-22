import app from "./src/server"
import db from "./src/configs/mysql"

const PORT = process.env.PORT || 5050

const startServer = async () => {
	await db.sync({ force: false })
	app.listen(PORT, "0.0.0.0", () => {
		console.log(`🚀 Server is running on 0.0.0.0:${PORT}`)
	})
}

startServer()
