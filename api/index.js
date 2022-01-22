import express from "express"
import { Sequelize, DataTypes } from "sequelize"
import cors from "cors"

const sequelize = new Sequelize({
	host: "localhost",
	username: "root",
	password: "root",
	database: "book_management",
	dialect: "mysql",
})

const Book = sequelize.define("books", {
	title: {
		type: DataTypes.STRING,
	},
	author_name: {
		type: DataTypes.STRING,
	},
})

const app = express()

app.use(cors("*"))
app.use(express.json())

const PORT = 5050

app.get("/test", (req, res) => {
	res.send("Hello World!")
})

app.post("/create_book", async (req, res) => {
	const { body } = req

	const book = await Book.create({
		title: body.title,
		author_name: body.author_name,
	})

	res.send({
		status: "success",
		book: book,
	})
})

app.get("/books", async (req, res) => {
	if (req.query.id) {
		const book = await Book.findAll({
			where: {
				id: req.query.id,
			},
		})
		res.send(book)
	} else {
		const books = await Book.findAll()
		res.send(books)
	}
})

app.get("/books/:id", async (req, res) => {
	const book = await Book.findByPk(req.params.id)
	res.send(book)
})

app.patch("/update_book/:id", async (req, res) => {
	const { body, params } = req
	const result = await Book.update(
		{
			title: body.title,
		},
		{
			where: {
				id: params.id,
			},
		}
	)

	if (!result[0]) {
		return res.send({
			status: "error",
			message: "book cannot found",
		})
	}

	res.send({
		status: "success",
		title: body.title,
	})
})

app.delete("/delete_book/:id", async (req, res) => {
	const { params } = req
	const result = await Book.destroy({
		where: {
			id: params.id,
		},
	})

	if (!result) {
		return res.send({
			status: "error",
			message: "book cannot found",
		})
	}

	res.send({
		status: "success",
	})
})

const startServer = async () => {
	await sequelize.sync()

	app.listen(PORT, () => {
		console.log(`Server is running on http://localhost:${PORT}`)
	})
}

startServer()
