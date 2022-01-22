import jwt from "jsonwebtoken"
import dotenv from "dotenv"
dotenv.config()

export const createToken = (payload) => {
	return jwt.sign(payload, process.env.JWT_SECRET)
}

export const verifyToken = (token) => {
	return jwt.verify(token, process.env.JWT_SECRET)
}
