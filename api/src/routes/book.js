import express from "express"
import authMiddleware from "../middlewares/auth"
import Book from "../model/Book"
import { Op } from "sequelize"
const router = express.Router()
router.use(authMiddleware)

router.post("/create_book", async (req, res) => {
	const { body } = req	

	const book = await Book.create({
		title: body.title,
		author_id: req.user.id,
	})

	res.send({
		status: "success",
		book: book,
	})
})

router.get("/books", async (req, res) => {
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

router.get("/books/:id", async (req, res) => {
	const book = await Book.findByPk(req.params.id)
	res.send(book)
})

router.patch("/update_book/:id", async (req, res) => {
	const { body, params } = req
	const result = await Book.update(
		{
			title: body.title,
		},
		{
			where: {
				[Op.and]: [{ id: params.id }, { author_id: req.user.id }],
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

router.delete("/delete_book/:id", async (req, res) => {
	const { params } = req
	const result = await Book.destroy({
		where: {
			[Op.and]: [{ id: params.id }, { author_id: req.user.id }],
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

export default router
