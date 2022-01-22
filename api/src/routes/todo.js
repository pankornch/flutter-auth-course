import express from "express"
import Joi from "joi"
import { Op } from "sequelize"
import auth from "../middlewares/auth"
const router = express.Router()
import Todo from "../models/Todo"

router.get("/", auth, async (req, res) => {
	const { user } = req
	const todos = await Todo.findAll({
		where: {
			user_id: user.id,
		},
	})
	res.json(todos)
})

router.get("/:id", auth, async (req, res) => {
	const { user, params } = req
	const todo = await Todo.findOne({
		where: {
			[Op.and]: [{ user_id: user.id }, { id: params.id }],
		},
	})

	if (!todo) {
		return res.status(404).json({ message: "page not found" })
	}

	res.json(todo)
})

router.post("/", auth, async (req, res) => {
	const { user, body } = req
	const { error } = Joi.object({
		name: Joi.string().required(),
		completed: Joi.boolean(),
	}).validate(body)

	if (error) {
		return res.status(400).json({ message: error })
	}

	try {
		const todo = await Todo.create({
			name: body.name,
			completed: body.completed,
			user_id: user.id,
		})

		res.status(201).json(todo)
	} catch (error) {
		res.status(500).json({
			error,
		})
	}
})

router.patch("/:id", auth, async (req, res) => {
	const { user, params, body } = req

	const { error } = Joi.object({
		name: Joi.string(),
		completed: Joi.boolean(),
	}).validate(body)

	if (error) {
		return res.status(400).json({ message: error })
	}

	const [result] = await Todo.update(
		body,
		{
			where: {
				[Op.and]: [{ user_id: user.id }, { id: params.id }],
			},
		},
		{}
	)

	if (!result) {
		return res.status(403).json({ message: "Incorrect todo id" })
	}

	const todo = await Todo.findByPk(params.id)

	res.json(todo.toJSON())
})

router.delete("/:id", auth, async (req, res) => {
	const { user, params } = req

	try {
		const result = await Todo.destroy({
			where: {
				[Op.and]: [{ user_id: user.id }, { id: params.id }],
			},
		})

		if (!result) {
			return res.status(403).json({ message: "Incorrect todo id" })
		}

		res.json({ success: true })
	} catch (error) {
		res.status(500).json({
			error,
		})
	}
})
export default router
