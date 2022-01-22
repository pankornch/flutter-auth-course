import express from "express"
import bcrypt from "bcryptjs"
import User from "../models/User"
import Joi from "joi"
import { createToken } from "../utils/token"

const router = express.Router()

router.post("/login", async (req, res) => {
	const { body } = req

	const { error } = Joi.object({
		username: Joi.string().required(),
		password: Joi.string().required(),
	}).validate(body)

	const user = await User.findOne({
		where: {
			username: body.username,
		},
	})

	if (error) {
		return res.status(400).json({
			message: error,
		})
	}

	if (!user) {
		return res.status(401).json({
			message: "Incorrect username or password!",
		})
	}

	if (!bcrypt.compareSync(body.password, user.password)) {
		return res.status(401).json({
			message: "Incorrect username or password!",
		})
	}
	const token = createToken({ sub: user.id })
	const userJson = user.toJSON()
	delete userJson.password
	res.status(201).json({
		user: userJson,
		token,
	})
})

router.post("/register", async (req, res) => {
	const { body } = req
	const { error } = Joi.object({
		username: Joi.string().required(),
		password: Joi.string().required(),
	}).validate(body)

	if (error) {
		return res.status(400).json({
			message: error,
		})
	}
	try {
		const user = await User.create({
			username: body.username,
			password: bcrypt.hashSync(body.password),
		})

		const token = createToken({ sub: user.id })
		const userJson = user.toJSON()
		delete userJson.password
		res.status(201).json({
			user: userJson,
			token,
		})
	} catch (error) {
		res.status(500).json({ errror: error })
	}
})

export default router
